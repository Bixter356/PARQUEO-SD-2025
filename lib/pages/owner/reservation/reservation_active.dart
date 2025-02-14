import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/models/to_use/reservation_request.dart';

class ReservasActivas extends StatelessWidget {
  const ReservasActivas({super.key});

  Stream<QuerySnapshot> getReservasStream() {
    return FirebaseFirestore.instance
      .collection('reserva')
      .where('parqueo.idDuenio', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('estado', isEqualTo: 'activo')
      .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Activas'),
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
              idPlaza: data['idPlaza'].toString(),
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
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Implementa aquí la lógica para abrir la pantalla de edición.
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

class ReservaActivaScreen extends StatefulWidget {
  final Reserva reserva;

  const ReservaActivaScreen({super.key, required this.reserva});

  @override
  State<ReservaActivaScreen> createState() => _ReservaActivaScreenState();
}

class _ReservaActivaScreenState extends State<ReservaActivaScreen> {
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

  @override
  void initState() {
    super.initState();
    getFullData();
  }

  Future<void> getFullData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Activas'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String id = widget.reserva.id;
                      //obtener el documento de la coleccion reserva
                      DocumentReference reservaRef = FirebaseFirestore.instance
                          .collection('reserva')
                          .doc(id);
                      //actualizar el estado de la reserva
                      reservaRef.update({'estado': 'finalizado'});

                      //actualizar el estado de la plaza //No se si falla o no
                      DocumentReference plazaRef = FirebaseFirestore.instance.doc(widget.reserva.idPlaza!);
                      plazaRef.update({'estado': 'disponible'});

                      Navigator.pop(context);
                    },
                    child: const Text('Finalizar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String id = widget.reserva.id;
                      //obtener el documento de la coleccion reserva
                      DocumentReference reservaRef = FirebaseFirestore.instance
                          .collection('reserva')
                          .doc(id);
                      //actualizar el estado de la reserva
                      reservaRef.update({'estado': 'rechazado'});

                      //actualizar el estado de la plaza //No se si falla o no
                      DocumentReference plazaRef = FirebaseFirestore.instance.doc(widget.reserva.idPlaza!);
                      plazaRef.update({'estado': 'disponible'});
                      Navigator.pop(context);
                    },
                    child: const Text('Caducar'),
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
