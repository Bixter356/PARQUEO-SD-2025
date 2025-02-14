import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreenTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculo De total gastado por cliente'),
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

          final reservas = snapshot.data!.docs
              .where((reserva) => reserva['estado'] == 'finalizado')
              .toList();

          // Cálculo del total gastado por cliente
          final totalPorCliente = Map<String, double>();

          reservas.forEach((reserva) {
            final cliente = reserva['cliente']['nombre'];
            final totalReserva = reserva['total'] ?? 0;
            totalPorCliente[cliente] =
                (totalPorCliente[cliente] ?? 0) + totalReserva;
          });

          return ListView(
            children: totalPorCliente.entries
                .map(
                  (entry) => Card(
                    child: ListTile(
                      title: Text('Cliente: ${entry.key}'),
                      subtitle: Text('Total gastado: ${entry.value}'),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportScreenTotal(),
  ));
}
