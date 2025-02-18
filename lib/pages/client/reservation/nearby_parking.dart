import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_3_27_4/models/to_use/parking.dart';
import 'package:app_3_27_4/pages/client/reservation/vistaParqueoDisponible.dart';

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
              'Parqueos Cercanos',
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
            backgroundColor: const Color(0xFF031b30)),
        body: const PlazaListScreen(),
      ),
    );
  }
}

class ParkLanding {
  bool automovil;
  bool moto;
  bool otro;
  Map<String, dynamic> dataPark;

  ParkLanding(
      {required this.automovil,
      required this.moto,
      required this.otro,
      required this.dataPark});
}

class PlazaListScreen extends StatefulWidget {
  const PlazaListScreen({super.key});

  @override
  PlazaListScreenState createState() => PlazaListScreenState();
}

class PlazaListScreenState extends State<PlazaListScreen> {
  List<ParkLanding> parkLanding = [];
  bool cargado = false;

  Future<void> checkFreePlaces() async {
    //obtener todos los parqueos
    CollectionReference parkingCollection =
        FirebaseFirestore.instance.collection('parqueo');
    // iterar sobre cada parqueo para ver si tiene almenos una plaza libre de cada tipo. los parqueos tienen plazas
    QuerySnapshot querySnapshot = await parkingCollection.get();
    for (var doc in querySnapshot.docs) {
      //obtener plazas
      CollectionReference placesCollection =
          parkingCollection.doc(doc.id).collection('plazas');

      // iniciar boleanos como falsos
      bool auto = false;
      bool moto = false;
      bool otro = false;

      QuerySnapshot placesSnapshot = await placesCollection.get();
      for (var placeDoc in placesSnapshot.docs) {
        Map<String, dynamic> data = placeDoc.data() as Map<String, dynamic>;
        if (data['estado'] == 'disponible') {
          if (data['tipoVehiculo'] == 'Automovil') {
            auto = true;
          } else if (data['tipoVehiculotipo'] == 'Moto') {
            moto = true;
          } else if (data['tipoVehiculo'] == 'Otro') {
            otro = true;
          }
        }
      }
      parkLanding.add(ParkLanding(
          automovil: auto,
          moto: moto,
          otro: otro,
          dataPark: doc.data() as Map<String, dynamic>));
    }
    cargado = true;
  }

  @override
  void initState() {
    super.initState();
    checkFreePlaces().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getParking(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !cargado) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (parkLanding.isEmpty) {
            return const Center(
              child: Text('No hay parqueos disponibles'),
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
              diasApertura: data['diasApertura'],
            );
          }).toList();
          return ListView.builder(
            itemCount: parqueos.length,
            itemBuilder: (context, index) {
              final parqueo = parqueos[index];
              return InkWell(
                onTap: () {
                  DataReservationSearch dataSearch =
                      DataReservationSearch(idParqueo: parqueo.idParqueo);
                  // Implementa aquí la lógica para abrir la pantalla de edición.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MostrarDatosParqueoScreen(dataSearch: dataSearch)),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: parkLanding[index].automovil
                              ? Colors.green
                              : Colors.red,
                        ),
                        Icon(
                          Icons.motorcycle,
                          color: parkLanding[index].moto
                              ? Colors.green
                              : Colors.red,
                        ),
                        Icon(
                          Icons.directions_bus,
                          color: parkLanding[index].otro
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
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
