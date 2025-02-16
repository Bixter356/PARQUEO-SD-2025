import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_3_27_4/models/to_use/parking.dart';
import 'package:app_3_27_4/pages/owner/parqueo/registro_parqueo.dart';
import 'package:app_3_27_4/pages/owner/plaza/create_place.dart';

class ParkingListScreen extends StatefulWidget {
  const ParkingListScreen({super.key});
  static const routeName = '/enable-parking';
  @override
  ParkingListScreenState createState() => ParkingListScreenState();
}

class ParkingListScreenState extends State<ParkingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'Mis parqueos',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF041657),
        ),
        body: StreamBuilder(
          stream: getParking(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            // Obtén la lista de plazas
            List<Parqueo> parqueos =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Parqueo(
                idParqueo: document.reference,
                nombre: data['nombre'],
                direccion: data['direccion'],
                ubicacion: data['ubicacion'],
                descripcion: data['descripcion'],
                vehiculosPermitidos: data['vehiculosPermitidos'],
                tarifaAutomovil: data['tarifaAutomovil'],
                tarifaMoto: data['tarifaMoto'],
                tarifaOtro: data['tarifaOtro'],
                horaApertura: data['horaApertura'],
                horaCierre: data['horaCierre'],
                idDuenio: data['idDuenio'],
                puntaje: data['puntaje'].toDouble(),
                diasApertura: data['diasApertura'],
              );
            }).toList();
            return ListView.builder(
              itemCount: parqueos.length,
              itemBuilder: (context, index) {
                final parqueo = parqueos[index];
                return InkWell(
                  onTap: () {
                    // context.pushNamedAndRemoveUntil(
                    //   Routes.registerPlaceScreen,
                    //   predicate: (route) => false,
                    //   arguments: [parqueo.idParqueo],
                    // );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePlaceScreen(
                          seccionRef: parqueo.idParqueo,
                        ),
                      ),
                    );
                    // Implementa aquí la lógica que se realizará al hacer clic en el elemento.
                    // Por ejemplo, puedes abrir una pantalla de detalles de la plaza.
                  },
                  child: Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        parqueo.nombre,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text(
                      //   parqueo.bool
                      //       ? 'Con Cobertura'
                      //       : 'Sin Cobertura',
                      //   style: const TextStyle(fontSize: 16.0),
                      // ),
                      trailing: IconButton(
                        icon: const Icon(Icons.car_repair,
                            color: Color.fromARGB(255, 1, 54, 97)),
                        onPressed: () {
                          //VEMTANA DE EDITAR PARQUEO
                          // DataReservationSearch dataSearch = DataReservationSearch(idParqueo: parqueo.idParqueo);
                          // // Implementa aquí la lógica para abrir la pantalla de edición.
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MostrarDatosParqueoScreen(dataSearch: dataSearch)
                          //   ),
                          // );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegistroParqueoScreen()),
            );
            // context.pushNamedAndRemoveUntil(
            //   Routes.registerParking,
            //   predicate: (route) => false,
            // );
          },
          backgroundColor: const Color.fromARGB(255, 1, 30, 54),
          child: const Icon(Icons.add, color: Colors.white),
        ));
  }

  Stream<QuerySnapshot> getParking() {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        CollectionReference parkingCollection =
            FirebaseFirestore.instance.collection('parqueo');
        return parkingCollection
            .where('idDuenio', isEqualTo: user.uid)
            .snapshots();
        // Filtra los documentos donde el campo 'IdDuenio' sea igual al user.uid
      } else {
        // Si el usuario no ha iniciado sesión, aún puedes devolver un Stream vacío o manejarlo de otra manera.
        return const Stream<QuerySnapshot>.empty();
      }
    } catch (e) {
      log('Error al obtener el Stream de parqueos: $e');
      rethrow;
    }
  }
}
