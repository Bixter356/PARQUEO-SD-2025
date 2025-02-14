import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cantidad total de horas reservadas'),
      ),
      backgroundColor: Colors.blue, 
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('reserva').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar los datos'),
            );
          }

          final reservas = snapshot.data!.docs.where((reserva) => reserva['estado'] == 'finalizado').toList();

          // Mapa para almacenar la duración total de cada cliente
          Map<String, double> duracionPorCliente = {};

          for (var reserva in reservas) {
            final cliente = reserva['cliente']['nombre'];
            final fechaLlegada = reserva['fechaLlegada']?.toDate();
            final fechaSalida = reserva['fechaSalida']?.toDate();

            if (fechaLlegada != null && fechaSalida != null) {
              final duracion = fechaSalida.difference(fechaLlegada).inHours.toDouble(); // Convertir a double
              duracionPorCliente.update(cliente, (value) => value + duracion, ifAbsent: () => duracion);
            }
          }
          return ListView.builder(
            itemCount: duracionPorCliente.length,
            itemBuilder: (context, index) {
              final cliente = duracionPorCliente.keys.elementAt(index);
              final duracionTotal = duracionPorCliente[cliente]!.round(); // Redondear a entero
              return Card(
                child: ListTile(
                  title: Text('Cliente: $cliente'),
                  subtitle: Text('Duración total de reservas: $duracionTotal horas'),
                  
                ),
                
              );
            },
          );
        },
      ),
    );
  }
}

// void main() {
//   runApp(const MaterialApp(
//     home: ReportScreen(),
//   ));
// }
