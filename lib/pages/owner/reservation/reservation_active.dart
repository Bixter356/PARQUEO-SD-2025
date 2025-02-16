import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_3_27_4/models/to_use/reservation_request.dart';
import 'package:intl/intl.dart';

class ReservasActivas extends StatelessWidget {
  const ReservasActivas({super.key});

  Stream<QuerySnapshot> getReservasStream() {
    return FirebaseFirestore.instance
        .collection('reserva')
        .where('parqueo.idDuenio',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('estado', isEqualTo: 'activo')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Reservas Activas',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF041657),
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

          List<Reserva> reservas =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

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
              total: data['total'].toDouble(),
              typeVehicle: data['vehiculo']['tipo'],
              id: document.id,
              idPlaza: data['idPlaza'].toString(),
            );
          }).toList();

          return ListView.builder(
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final reservaRequest = reservas[index];
              return InkWell(
                onTap: () {},
                child: Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      '${reservaRequest.nombreParqueo} - ${reservaRequest.total}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${reservaRequest.nombreCliente} ${reservaRequest.apellidoCliente} - ${reservaRequest.nombrePlaza}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReservaActivaScreen(reserva: reservaRequest),
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

class ReservaActivaScreen extends StatelessWidget {
  final Reserva reserva;

  const ReservaActivaScreen({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    TextEditingController totalController =
        TextEditingController(text: reserva.total.toString());
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Activas',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF02335B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.calendar_today, color: Colors.blue),
                    title: Text(
                      'Fecha: ${dateFormat.format(reserva.date)}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.green),
                    title: Text(
                      'Fecha de llegada: ${dateFormat.format(reserva.dateArrive)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.red),
                    title: Text(
                      'Fecha de salida: ${dateFormat.format(reserva.dateOut)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.directions_car, color: Colors.orange),
                    title: Text(
                      'Modelo: ${reserva.model}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.confirmation_number,
                        color: Colors.purple),
                    title: Text(
                      'Placa: ${reserva.plate}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.teal),
                    title: Text(
                      'Estado: ${reserva.status}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.attach_money, color: Colors.green),
                    title: Text(
                      'Total: ${reserva.total}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.directions_car_filled,
                        color: Colors.blueGrey),
                    title: Text(
                      'Tipo de vehículo: ${reserva.typeVehicle}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          String id = reserva.id;
                          DocumentReference reservaRef = FirebaseFirestore
                              .instance
                              .collection('reserva')
                              .doc(id);
                          reservaRef.update({
                            'estado': 'finalizado',
                            'total': double.parse(totalController.text)
                          });
                          DocumentReference plazaRef =
                              FirebaseFirestore.instance.doc(reserva.idPlaza!);
                          plazaRef.update({'estado': 'disponible'});
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check, color: Colors.green),
                        label: const Text('Finalizar'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green,
                            elevation: 4.0,
                            shadowColor: Colors.green),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          String id = reserva.id;
                          DocumentReference reservaRef = FirebaseFirestore
                              .instance
                              .collection('reserva')
                              .doc(id);
                          reservaRef.update({'estado': 'rechazado'});
                          DocumentReference plazaRef =
                              FirebaseFirestore.instance.doc(reserva.idPlaza!);
                          plazaRef.update({'estado': 'disponible'});
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: const Text('Caducar'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          elevation: 4.0,
                          shadowColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
