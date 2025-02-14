import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parking_project/models/to_use/reservation_request.dart';

import 'package:flutter/foundation.dart';
import 'package:parking_project/services/temporal.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReservasFinalizadas extends StatelessWidget {
  const ReservasFinalizadas({super.key});

  Stream<QuerySnapshot> getReservasStream() {

    //QuerySnapshot parqueos = FirebaseFirestore.instance.collection('parqueo').get() as QuerySnapshot;

    return FirebaseFirestore.instance
      .collection('reserva')
      .where('parqueo.idDuenio', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('estado', isEqualTo: 'finalizado')
      .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Finalizadas'),
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

            // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.doc(data['idVehiculo']).get();
            // Map<String, dynamic> vehiculoData = documentSnapshot.data() as Map<String, dynamic>;

            // Aquí puedes realizar las operaciones necesarias con los datos del vehículo

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
                      '${reservaRequest.nombreParqueo} - ${reservaRequest.total}',
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
                        // Implementa aquí la lógica para abrir la pantalla de edición.
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
  TextEditingController nombreParqueo = TextEditingController();
  TextEditingController pisoController = TextEditingController();
  TextEditingController filaController = TextEditingController();
  TextEditingController plazaController = TextEditingController();
  TextEditingController placaController = TextEditingController();
  TextEditingController marcaController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController modeloController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaFinController = TextEditingController();

  DateTime? reservationDateIn, reservationDateOut;
  bool radioValue = false;
  List<bool> checkboxValues = [false, false, false];
  String typeVehicle = "";
  String urlImage = "";

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Finalizadas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha: ${widget.reserva.date}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fecha de llegada: ${widget.reserva.dateArrive}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fecha de salida: ${widget.reserva.dateOut}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Modelo: ${widget.reserva.model}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Placa: ${widget.reserva.plate}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Estado: ${widget.reserva.status}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Total: ${widget.reserva.total}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Tipo de vehículo: ${widget.reserva.typeVehicle}',
                style: const TextStyle(fontSize: 16.0),
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
                      const SizedBox(
                          height:
                              20), // Añade un espacio entre la barra de calificación y el botón
                      ElevatedButton(
                        onPressed: () async {
                          // Aquí puedes agregar la lógica para guardar el rating
                          if (kDebugMode) {
                            print('Botón presionado');

                            // Obtener y usar el usuario existente
                            //Usuario usuario = await obtenerUsuario(FirebaseAuth.instance.currentUser!.uid); //Aquien se calificara

                            // Actualizar el puntaje del usuario

                            DocumentReference reservaRef = FirebaseFirestore
                                .instance
                                .collection('reserva')
                                .doc(widget.reserva.id);

                            reservaRef.update({'calificacionDuenio': true});
                            await updateItem(number, widget.reserva.idCliente!);
                            if(!context.mounted) return;
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
                      //String id = widget.reserva.id;
                      //obtener el documento de la coleccion reserva
                      // DocumentReference reservaRef = FirebaseFirestore.instance
                      //     .collection('reserva')
                      //     .doc(id);
                      // //actualizar el estado de la reserva
                      // reservaRef.update({'estado': 'rechazado'});
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
    );
  }
}
