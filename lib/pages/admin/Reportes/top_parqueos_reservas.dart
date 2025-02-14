import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreenParkingReserves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking de parqueos con mas reservaciones'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('reserva').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los datos'),
            );
          }

          final reservas = snapshot.data!.docs.where((reserva) => reserva['estado'] == 'finalizado').toList();

          // Cálculo del top parqueos con más reservas
          final parqueosReservas = Map<String, int>();

          reservas.forEach((reserva) {
            final parqueo = reserva['parqueo']['nombre'];
            parqueosReservas[parqueo] =
                (parqueosReservas[parqueo] ?? 0) + 1;
          });

          // Ordenar la lista de parqueos por cantidad de reservas
          final sortedParqueosReservas = parqueosReservas.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView.builder(
            itemCount: sortedParqueosReservas.length > 2
                ? 2
                : sortedParqueosReservas.length,
            itemBuilder: (context, index) {
              final parqueo = sortedParqueosReservas[index];
              return Card(
                child: ListTile(
                  title: Text(
                      'Parqueo ${index + 1}: ${parqueo.key}'),
                  subtitle: Text(
                      'Cantidad de reservas: ${parqueo.value}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportScreenParkingReserves(),
  ));
}
