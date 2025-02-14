import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/models/to_use/reservation_request.dart';
import 'package:parking_project/pages/owner/reservation/reservation_data.dart';

class ReservasPendientes extends StatelessWidget {
  const ReservasPendientes({super.key});

  Stream<QuerySnapshot> getReservasStream() {
    return FirebaseFirestore.instance
      .collection('reserva')
      .where('parqueo.idDuenio', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('estado', isEqualTo: 'pendiente')
      .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Pendientes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getReservasStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Obtén la lista de plazas
          List<Reserva> reservas =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            //DocumentReference idDocumento = document.reference; // Obtener

            return Reserva(
              nombreCliente: data['cliente']['nombre'],
              apellidoCliente: data['cliente']['apellidos'],
              nombreParqueo: data['parqueo']['nombre'],
              nombrePlaza: data['parqueo']['plaza'],

              date: data['fecha'].toDate(),
              dateArrive: data['fechaLlegada'].toDate(),
              dateOut: data['fechaSalida'].toDate(),
              model: data['vehiculo']['marcaVehiculo'],
              plate: data['vehiculo']['placaVehiculo'],
              status: data['estado'],
              total: data['total'],
              typeVehicle: data['vehiculo']['tipo'],
              id: document.id,
            );
          }).toList();

          return ListView.builder(
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final reservaRequest = reservas[index];
              return InkWell(
                onTap: () {
                  // Implementa aquí la lógica que se realizará al hacer clic en el elemento.
                  // Por ejemplo, puedes abrir una pantalla de detalles de la plaza.
                },
                child: Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      '${reservaRequest.nombreParqueo!} - ${reservaRequest.total.toString()} bs',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      ' ${reservaRequest.nombreCliente} ${reservaRequest.apellidoCliente} - ${reservaRequest.nombrePlaza}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Implementa aquí la lógica para abrir la pantalla de edición.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReservaRequestScreen(reserva: reservaRequest),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
