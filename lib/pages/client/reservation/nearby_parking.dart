import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/models/to_use/parking.dart';
import 'package:parking_project/pages/client/reservation/vistaParqueoDisponible.dart';

class SelectParkingScreen extends StatelessWidget {
  static const routeName = '/nearby-parking';
  const SelectParkingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Parqueos Cercanos Disponibles',
              style: TextStyle(color: Colors.white),
            ),
          leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
            backgroundColor: const Color.fromARGB(255, 5, 126, 225)),
        body: const PlazaListScreen(),
      ),
    );
  }
}

class PlazaListScreen extends StatefulWidget {
  const PlazaListScreen({super.key});

  @override
  PlazaListScreenState createState() => PlazaListScreenState();
}

class PlazaListScreenState extends State<PlazaListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                diasApertura: data['diasApertura'],);
          }).toList();
          return ListView.builder(
            itemCount: parqueos.length,
            itemBuilder: (context, index) {
              final parqueo = parqueos[index];
              return InkWell(
                onTap: () {
                  DataReservationSearch dataSearch = DataReservationSearch(idParqueo: parqueo.idParqueo);
                  // Implementa aquí la lógica para abrir la pantalla de edición.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MostrarDatosParqueoScreen(dataSearch: dataSearch)
                    ),
                  );
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
                    //   parqueo.tieneCobertura
                    //       ? 'Con Cobertura'
                    //       : 'Sin Cobertura',
                    //   style: const TextStyle(fontSize: 16.0),
                    // ),
                    trailing: IconButton(
                      icon: const Icon(Icons.car_repair, color: Colors.blue),
                      onPressed: () {
                        DataReservationSearch dataSearch = DataReservationSearch(idParqueo: parqueo.idParqueo);
                        // Implementa aquí la lógica para abrir la pantalla de edición.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MostrarDatosParqueoScreen(dataSearch: dataSearch)
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

  // Función para abrir detalles de la plaza
  void abrirDetallesPlaza(Plaza plaza) {
    // Implementa aquí la lógica para mostrar los detalles de la plaza.
    // Puedes navegar a una nueva pantalla de detalles, por ejemplo.
  }

  // // Función para editar la plaza
  // void editarPlaza(Plaza plaza) {
  //   // Implementa aquí la lógica para editar la plaza.
  //   // Puedes navegar a la pantalla de edición y pasar la plaza como argumento.
  // }
}

Future<void> agregarDocumentoASubcoleccion(String idParqueo, String idPiso,
    String idFila, Map<String, dynamic> datos) async {
  // Obtén una referencia a la colección principal, en este caso, 'parqueos'
  CollectionReference parqueos =
      FirebaseFirestore.instance.collection('parqueo');
  // Obtén una referencia al documento del parqueo
  DocumentReference parqueoDocRef = parqueos.doc("ID-PARQUEO-3");
  // Obtén una referencia a la subcolección 'pisos' dentro del documento del parqueo
  CollectionReference pisos = parqueoDocRef.collection('pisos');
  // Obtén una referencia al documento del piso
  DocumentReference pisoDocRef = pisos.doc('ID-PISO-1');
  // Obtén una referencia a la subcolección 'filas' dentro del documento del piso
  CollectionReference filas = pisoDocRef.collection('filas');
  // Obtén una referencia al documento de la fila
  DocumentReference filaDocRef = filas.doc('ID-FILA-1');
  // Obtén una referencia a la subcolección 'plazas' dentro del documento de la fila
  CollectionReference plazasCollection = filaDocRef.collection('plazas');
  // Usa set para agregar el documento con los datos proporcionados
  await plazasCollection.doc().set(datos);
}

Future<void> editarPlaza(String idParqueo, String idPiso, String idFila,
    String idPlaza, Map<String, dynamic> datos) async {
  try {
    // Obtén una referencia al documento de la plaza que deseas editar
    DocumentReference plazaDocRef = FirebaseFirestore.instance
        .collection('parqueo')
        .doc(idParqueo)
        .collection('pisos')
        .doc(idPiso)
        .collection('filas')
        .doc(idFila)
        .collection('plazas')
        .doc(idPlaza);

    // Utiliza update para modificar campos existentes o set con merge: true para combinar datos nuevos con los existentes
    await plazaDocRef.update(
        datos); // Utiliza update para modificar campos existentes o set con merge: true
  } catch (e) {
    log('Error al editar la plaza: $e');
  }
}

Future<List<Plaza>> getPlaces(
    String idParqueo, String idPiso, String idFila) async {
  try {
    CollectionReference plazasCollection = FirebaseFirestore.instance
        .collection('parqueo')
        .doc(idParqueo)
        .collection('pisos')
        .doc(idPiso)
        .collection('filas')
        .doc(idFila)
        .collection('plazas');

    QuerySnapshot querySnapshot = await plazasCollection.get();

    // Mapea los documentos en objetos de la clase Plaza
    List<Plaza> plazas = querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return Plaza(
          nombre: data['nombre'],
          tipo: data['tipo'],
          idPlaza: document.reference,
          estado: data['estado']);
    }).toList();

    return plazas;
  } catch (e) {
    log('Error al obtener las plazas: $e');
    return [];
  }
}

Stream<QuerySnapshot> obtenerPlazasStream(
    String idParqueo, String idPiso, String idFila) {
  try {
    CollectionReference plazasCollection = FirebaseFirestore.instance
        .collection('parqueo')
        .doc(idParqueo)
        .collection('pisos')
        .doc(idPiso)
        .collection('filas')
        .doc(idFila)
        .collection('plazas');
    return plazasCollection
        .snapshots(); // Devuelve un Stream que escucha cambios en la colección.
  } catch (e) {
    log('Error al obtener el Stream de plazas: $e');
    rethrow;
  }
}

Stream<QuerySnapshot> getParking() {
  try {
    CollectionReference parkingCollection =
        FirebaseFirestore.instance.collection('parqueo');
    return parkingCollection
        .snapshots(); // Devuelve un Stream que escucha cambios en la colección.
  } catch (e) {
    log('Error al obtener el Stream de parqueos: $e');
    rethrow;
  }
}
