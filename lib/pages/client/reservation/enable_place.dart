import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_3_27_4/models/to_use/parking.dart';
import 'package:app_3_27_4/pages/client/reservation/reservationRegister.dart';

class SelectSpaceScreen extends StatelessWidget {
  final DataReservationSearch dataSearch;
  static const routeName = '/enable-parking';
  const SelectSpaceScreen({super.key, required this.dataSearch});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Plazas Disponibles',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF031b30)),
      body: PlazaListScreen(
        dataSearch: dataSearch,
      ),
    );
  }
}

class PlazaListScreen extends StatefulWidget {
  final DataReservationSearch dataSearch;
  const PlazaListScreen({super.key, required this.dataSearch});

  @override
  PlazaListScreenState createState() => PlazaListScreenState();
}

class PlazaListScreenState extends State<PlazaListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getSpaces(widget.dataSearch),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<Plaza> plazas =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Plaza(
              idPlaza: document.reference,
              nombre: data['nombre'],
              estado: data['estado'],
              tipo: data['tipoVehiculo'],
            );
          }).toList();

          if (plazas.isEmpty) {
            //Toast.show(context, "${widget.dataSearch.tieneCobertura} - ${widget.dataSearch.tipoVehiculo}");
            // No se encontraron plazas disponibles
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No se encontró una plaza disponible'),
                  ElevatedButton(
                    onPressed: () {
                      // Volver a realizar la búsqueda
                      Navigator.pop(context);
                    },
                    child: const Text('Volver a realizar la búsqueda'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: plazas.length,
            itemBuilder: (context, index) {
              final plaza = plazas[index];

              return InkWell(
                onTap: () {
                  DataReservationSearch dataSearch = widget.dataSearch;
                  dataSearch.plaza = plaza.nombre;
                  dataSearch.idPlaza = plaza.idPlaza;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReservaRegisterScreen(dataSearch: dataSearch)),
                  );
                },
                child: Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      plaza.nombre,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text(
                    //   plaza.tieneCobertura ? 'Con Cobertura' : 'Sin Cobertura',
                    //   style: const TextStyle(fontSize: 16.0),
                    // ),
                    trailing: IconButton(
                      icon: const Icon(Icons.local_parking, color: Colors.blue),
                      onPressed: () {
                        DataReservationSearch dataSearch = widget.dataSearch;
                        dataSearch.plaza = plaza.nombre;
                        dataSearch.idPlaza = plaza.idPlaza;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservaRegisterScreen(
                                  dataSearch: dataSearch)),
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
    log('log: Error al obtener el Stream de plazas: $e');
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

Stream<List<Plaza>> getSpacesRealTime() {
  // Inicializa Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  return firestore
      .collection('parqueo') // Colección principal
      .doc('ID-PARQUEO-3') // ID del documento de parqueo actual
      .collection('piso') // Subcolección piso
      .snapshots() // Escucha cambios en la colección de pisos
      .asyncMap((pisoQuerySnapshot) async {
    List<Plaza> spaces = [];

    // Recorre los documentos de 'piso'
    for (QueryDocumentSnapshot pisoDocument in pisoQuerySnapshot.docs) {
      // Realiza la consulta en la colección 'fila' dentro de cada 'piso'
      QuerySnapshot filaQuerySnapshot = await firestore
          .collection('parqueo') // Colección principal
          .doc('ID-PARQUEO-3') // ID del documento de parqueo actual
          .collection('piso') // Subcolección piso
          .doc(pisoDocument.id) // ID del documento de piso actual
          .collection('fila') // Subcolección fila
          .get();

      // Recorre los documentos de 'fila'
      for (QueryDocumentSnapshot filaDocument in filaQuerySnapshot.docs) {
        // Realiza la consulta en la colección 'plaza' dentro de cada 'fila'
        QuerySnapshot plazaQuerySnapshot = await firestore
            .collection('parqueo') // Colección principal
            .doc('ID-PARQUEO-3') // ID del documento de parqueo actual
            .collection('piso') // Subcolección piso
            .doc(pisoDocument.id) // ID del documento de piso actual
            .collection('fila') // Subcolección fila
            .doc(filaDocument.id) // ID del documento de fila actual
            .collection('plaza') // Subcolección plaza
            .where('estado', isEqualTo: 'Disponible') // Condición de búsqueda
            .get();

        // Recorre los documentos resultantes de 'plaza' para la 'fila' actual
        for (QueryDocumentSnapshot plazaDocument in plazaQuerySnapshot.docs) {
          // Accede a la información de la 'plaza'
          //Map<String, dynamic> plazaData = plazaDocument.data() as Map<String, dynamic>;
        }
      }
    }

    return spaces;
  });
}

// Stream<QuerySnapshot> getSpaces(DataReservationSearch dataSearch) async* {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   QuerySnapshot pisoQuerySnapshot = await dataSearch.idParqueo.collection(SubCollectionParking.pisos).get();

//   for (QueryDocumentSnapshot pisoDocument in pisoQuerySnapshot.docs) {
//     Map<String, dynamic> pisoData = pisoDocument.data() as Map<String, dynamic>;

//     QuerySnapshot filaQuerySnapshot = await dataSearch.idParqueo
//         .collection('pisos')
//         .doc(pisoDocument.id)
//         .collection('filas')
//         .get();

//     for (QueryDocumentSnapshot filaDocument in filaQuerySnapshot.docs) {
//       Map<String, dynamic> filaData =
//           filaDocument.data() as Map<String, dynamic>;

//       // Utiliza 'snapshots' para escuchar cambios en tiempo real
//       Stream<QuerySnapshot> plazaQuerySnapshot = dataSearch.idParqueo
//           .collection(SubCollectionParking.filas)
//           .doc(pisoDocument.id)
//           .collection(SubCollectionParking.filas)
//           .doc(filaDocument.id)
//           .collection(SubCollectionParking.plazas)
//           .where('estado', isEqualTo: 'disponible')
//           .where('tieneCobertura', isEqualTo: dataSearch.tieneCobertura)
//           .where('tipoVehiculo', isEqualTo: dataSearch.tipoVehiculo)
//           .snapshots();

//       // Utiliza 'async* {}' para emitir los resultados en el Stream
//       await for (QuerySnapshot snapshot in plazaQuerySnapshot) {
//         // Aquí emite el QuerySnapshot de las plazas que pasaron el filtrado
//         yield snapshot;
//       }
//     }
//   }
// }
Stream<QuerySnapshot> getSpaces(DataReservationSearch dataSearch) async* {
  final Query plazaQuery = dataSearch.idParqueo
      .collection('plazas')
      .where('estado', isEqualTo: 'disponible')
      .where('tipoVehiculo', isEqualTo: dataSearch.tipoVehiculo);

  final Stream<QuerySnapshot> plazaQueryStream = plazaQuery.snapshots();

  await for (QuerySnapshot snapshot in plazaQueryStream) {
    yield snapshot;
  }
}

Future<QuerySnapshot> getCollectionSnapshot(
    CollectionReference collectionRef) async {
  return await collectionRef.get();
}
