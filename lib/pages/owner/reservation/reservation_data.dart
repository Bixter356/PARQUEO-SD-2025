import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_3_27_4/models/to_use/reservation_request.dart';
import 'package:intl/intl.dart';

class ReservaRequestScreen extends StatelessWidget {
  final Reserva reserva;

  const ReservaRequestScreen({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    TextEditingController totalController =
        TextEditingController(text: reserva.total.toString());
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Pendientes',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF031b30),
        // cambiar el color del icono de la flecha de regreso
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
                    title: TextFormField(
                      controller: totalController,
                      decoration: const InputDecoration(
                        labelText: 'Total',
                        border: OutlineInputBorder(),
                      ),
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
                            'estado': 'activo',
                            'total': double.parse(totalController.text)
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check, color: Colors.green),
                        label: const Text('Aceptar'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green,
                            // remarcar la sombra del botón
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
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: const Text('Rechazar'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          // remarcar la sombra del botón
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
