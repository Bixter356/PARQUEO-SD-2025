import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:app_3_27_4/models/to_use/reservation_request.dart';
import 'package:flutter/foundation.dart';
import 'package:app_3_27_4/services/temporal.dart';
import 'package:intl/intl.dart';

class ReservasFinalizadas extends StatelessWidget {
  const ReservasFinalizadas({super.key});

  Stream<QuerySnapshot> getReservasStream() {
    return FirebaseFirestore.instance
        .collection('reserva')
        .where('parqueo.idDuenio',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('estado', isEqualTo: 'finalizado')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Reservas Finalizadas',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF031b30),
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
                      '${reservaRequest.nombreParqueo} - ${reservaRequest.total} Bs',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${reservaRequest.nombreCliente} ${reservaRequest.apellidoCliente} - ${reservaRequest.nombrePlaza}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.read_more, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservaFinalizadaScreen(
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

class ReservaFinalizadaScreen extends StatefulWidget {
  final Reserva reserva;

  const ReservaFinalizadaScreen({super.key, required this.reserva});

  @override
  State<ReservaFinalizadaScreen> createState() =>
      _ReservaFinalizadaScreenState();
}

class _ReservaFinalizadaScreenState extends State<ReservaFinalizadaScreen> {
  bool calificacionDuenio = true;

  @override
  void initState() {
    super.initState();
    getFullData();
  }

  Future<void> getFullData() async {
    DocumentSnapshot reservaSnapshot = await FirebaseFirestore.instance
        .collection('reserva')
        .doc(widget.reserva.id)
        .get();
    Map<String, dynamic> data = reservaSnapshot.data() as Map<String, dynamic>;
    setState(() {
      calificacionDuenio = data['calificacionDuenio'];
    });
  }

  @override
  Widget build(BuildContext context) {
    int number = 0;
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservas Finalizadas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF02335B),
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
                  const SizedBox(height: 16.0),
                  if (!calificacionDuenio)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              if (kDebugMode) {
                                print(rating);
                                number = rating.toInt();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (kDebugMode) {
                                print('Botón presionado');
                                DocumentReference reservaRef = FirebaseFirestore
                                    .instance
                                    .collection('reserva')
                                    .doc(widget.reserva.id);

                                reservaRef.update({'calificacionDuenio': true});
                                await updateItem(
                                    number, widget.reserva.idCliente!);
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Guardar Calificación'),
                          ),
                        ],
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
