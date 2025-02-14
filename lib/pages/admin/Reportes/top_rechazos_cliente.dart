import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreenRejectClient extends StatelessWidget {
  const ReportScreenRejectClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes con mas rechazos'),
      ),
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
          final reservas = snapshot.data!.docs.where((reserva) => reserva['estado'] == 'cancelado').toList();

          // Cálculo del top cliente con más reservas
          final clientesReservas = <String, int>{};

          for (var reserva in reservas) {
            final cliente = reserva['cliente']['nombre'];
            clientesReservas[cliente] =
                (clientesReservas[cliente] ?? 0) + 1;
          }

          // Ordenar la lista de clientes por cantidad de reservas
          final sortedClientesReservas = clientesReservas.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView.builder(
            itemCount: sortedClientesReservas.length > 20
                ? 20
                : sortedClientesReservas.length,
            itemBuilder: (context, index) {
              final cliente = sortedClientesReservas[index];
              return Card(
                child: ListTile(
                  title: Text(
                      'Cliente No ${index + 1}: ${cliente.key}'),
                  subtitle: Text(
                      'Cantidad de rechazos: ${cliente.value}'),
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
//     home: ReportScreenRankingReserves(),
//   ));
// }
