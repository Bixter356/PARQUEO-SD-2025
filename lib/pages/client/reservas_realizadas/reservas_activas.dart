import 'dart:developer';

import 'package:app_3_27_4/pages/client/navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_3_27_4/models/to_use/reservation_request.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservasActivasCliente extends StatelessWidget {
  const ReservasActivasCliente({super.key});

  Stream<QuerySnapshot> getReservasStream() {
    return FirebaseFirestore.instance
        .collection('reserva')
        .where('idCliente', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
        backgroundColor: const Color(0xFF02335B),
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
            DocumentReference docc = data['idParqueo'];
            DocumentReference docc2 = data['idPlaza'];

            return Reserva(
              idCliente: data['cliente']['idCliente'],
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
              idDuenio: data['parqueo']['idDuenio'],
              idParqueo: docc.id,
              idPlaza: docc2.id,
            );
          }).toList();

          return ListView.builder(
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final reservaRequest = reservas[index];
              return InkWell(
                onTap: () {
                  // Implementa aquí la lógica que se realizará al hacer clic en el elemento.
                },
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
                                ReservaFinalizadaClienteScreen(
                                    reserva: reservaRequest),
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

class ReservaFinalizadaClienteScreen extends StatefulWidget {
  final Reserva reserva;

  const ReservaFinalizadaClienteScreen({super.key, required this.reserva});

  @override
  State<ReservaFinalizadaClienteScreen> createState() =>
      _ReservaFinalizadaClienteScreenState();
}

class _ReservaFinalizadaClienteScreenState
    extends State<ReservaFinalizadaClienteScreen> {
  TextEditingController totalController = TextEditingController();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  String uniqueCode = '';

  @override
  void initState() {
    super.initState();
    totalController.text = widget.reserva.total.toString();
    generateUniqueCode();
  }

  void generateUniqueCode() {
    setState(() {
      uniqueCode = '${widget.reserva.idParqueo}-${widget.reserva.idPlaza}-${widget.reserva.id}-${widget.reserva.idCliente}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva Activa'),
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
                      'Fecha: ${dateFormat.format(widget.reserva.date)}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.green),
                    title: Text(
                      'Fecha de llegada: ${dateFormat.format(widget.reserva.dateArrive)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.red),
                    title: Text(
                      'Fecha de salida: ${dateFormat.format(widget.reserva.dateOut)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.directions_car, color: Colors.orange),
                    title: Text(
                      'Modelo: ${widget.reserva.model}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.confirmation_number,
                        color: Colors.purple),
                    title: Text(
                      'Placa: ${widget.reserva.plate}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.teal),
                    title: Text(
                      'Estado: ${widget.reserva.status}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.attach_money, color: Colors.green),
                    title: Text(
                      'Total: ${widget.reserva.total}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.directions_car_filled,
                        color: Colors.blueGrey),
                    title: Text(
                      'Tipo de vehículo: ${widget.reserva.typeVehicle}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.qr_code, color: Colors.black),
                    title: Text(
                      'Escanea el código QR para ver la reserva',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: QrImageView(
                      data: uniqueCode,
                      version: QrVersions.auto,
                      size: 300.0,
                      gapless: false,
                      errorStateBuilder: (context, error) => const Center(
                        child: Text(
                          'Error al generar el QR',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Código: $uniqueCode',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Volver'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuClient(),
                            ),
                          );
                        },
                        child: const Text('Volver al menú'),
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
