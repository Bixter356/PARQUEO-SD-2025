import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/models/to_use/parking.dart';

class CreatePlaceScreen extends StatelessWidget {
  static const routeName = '/create-place-srceen';
  final DocumentReference seccionRef;
  const CreatePlaceScreen({super.key, required this.seccionRef});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Lista de Plazas'),
            backgroundColor: const Color.fromARGB(255, 5, 126, 225)),
        body: PlazaListScreen(seccionRef: seccionRef),
      ),
    );
  }
}

class PlazaListScreen extends StatefulWidget {
  final DocumentReference seccionRef;
  const PlazaListScreen({super.key, required this.seccionRef});

  @override
  PlazaListScreenState createState() => PlazaListScreenState();
}

class PlazaListScreenState extends State<PlazaListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: obtenerPlazasStream(widget.seccionRef),
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
          List<Plaza> plazas =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            DocumentReference idDocumento = document.reference; // Obtener
            return Plaza(
              idPlaza: idDocumento,
              nombre: data['nombre'],
              estado: data['estado'],
              tipo: data['tipoVehiculo'],
            );
          }).toList();

          return ListView.builder(
            itemCount: plazas.length,
            itemBuilder: (context, index) {
              final plaza = plazas[index];
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
                      plaza.nombre,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      plaza.estado == 'disponible'
                          ? 'Disponible : ${plaza.tipo}'
                          : 'No disponible : ${plaza.tipo}',
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
                                EditarPlazaScreen(idPlaza: plaza.idPlaza),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AgregarPlazaScreen(seccionRef: widget.seccionRef)),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
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

class AgregarPlazaScreen extends StatefulWidget {
  final DocumentReference seccionRef;
  const AgregarPlazaScreen({super.key, required this.seccionRef});

  @override
  AgregarPlazaScreenState createState() => AgregarPlazaScreenState();
}

class AgregarPlazaScreenState extends State<AgregarPlazaScreen> {
  String nombre = '';
  String tipoVehiculo = '';
  bool tieneCobertura = false;
  String descripcion = '';
  String estado = 'disponible';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nueva Plaza'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Alinear los elementos al ancho completo
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    nombre = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Tipo de Vehículo',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 'Moto',
                    groupValue: tipoVehiculo,
                    onChanged: (val) {
                      setState(() {
                        tipoVehiculo = val!;
                      });
                    },
                  ),
                  const Text('Moto'),
                  Radio(
                    value: 'Automovil',
                    groupValue: tipoVehiculo,
                    onChanged: (val) {
                      setState(() {
                        tipoVehiculo = val!;
                      });
                    },
                  ),
                  const Text('Automóvil'),
                  Radio(
                    value: 'Otro',
                    groupValue: tipoVehiculo,
                    onChanged: (val) {
                      setState(() {
                        tipoVehiculo = val!;
                      });
                    },
                  ),
                  const Text('Otro'),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Estado de la plaza',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 'disponible',
                    groupValue: estado,
                    onChanged: (val) {
                      setState(() {
                        estado = val!;
                      });
                    },
                  ),
                  const Text('Disponible'),
                  Radio(
                    value: 'noDisponible',
                    groupValue: estado,
                    onChanged: (val) {
                      setState(() {
                        estado = val!;
                      });
                    },
                  ),
                  const Text('No Disponible'),
                ],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descripcion',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    descripcion = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> datos = {
                    'nombre': nombre, // Nombre de la plaza
                    'tipoVehiculo': tipoVehiculo, // Tipo de vehículo permitido
                    'tieneCobertura':
                        tieneCobertura, // Indica si tiene cobertura o no
                    'descripcion': descripcion, // Piso y Fila
                    'estado': estado, // Estado
                  };
                  // Llama a la función para agregar el documento a la subcolección
                  await agregarDocumentoASubcoleccion(widget.seccionRef, datos);
                  // Crea una nueva Plaza y devuelve los datos a la pantalla anterior.
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0), // Espaciado vertical para el botón
                ),
                child: const Text(
                  'Agregar Plaza',
                  style:
                      TextStyle(fontSize: 18.0), // Tamaño de fuente del botón
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditarPlazaScreen extends StatefulWidget {
  final DocumentReference idPlaza; // Recibe el ID de la plaza

  const EditarPlazaScreen({super.key, required this.idPlaza});

  @override
  EditarPlazaScreenState createState() => EditarPlazaScreenState();
}

class EditarPlazaScreenState extends State<EditarPlazaScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  String tipoVehiculo = '';
  bool tieneCobertura = false;
  String estado = 'noDisponible';
  String descripcion = '';

  @override
  void initState() {
    super.initState();
    cargarDatosPlaza(); // Carga los datos de la plaza en initState
  }

  Future<void> cargarDatosPlaza() async {
    try {
      // DocumentSnapshot<Map<String, dynamic>> plazaDoc = await FirebaseFirestore
      //     .instance
      //     .collection('parqueo')
      //     .doc('ID-PARQUEO-3')
      //     .collection('pisos')
      //     .doc('ID-PISO-1')
      //     .collection('filas')
      //     .doc('ID-FILA-1')
      //     .collection('plazas')
      //     .doc(widget.idPlaza) // Usa el ID de la plaza pasado como argumento
      //     .get();
      DocumentReference plazaRef = widget.idPlaza;
      DocumentSnapshot<Map<String, dynamic>> plazaDoc =
          await plazaRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (plazaDoc.exists) {
        Map<String, dynamic> data = plazaDoc.data() as Map<String, dynamic>;
        setState(() {
          nombreController.text = data['nombre'];
          tipoVehiculo = data['tipoVehiculo'];
          descripcionController.text = data['descripcion'];
          estado = data['estado'];
        });
      }
    } catch (e) {
      log('Error al cargar los datos de la plaza: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Plaza'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Tipo de Vehículo',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Moto',
                  groupValue: tipoVehiculo,
                  onChanged: (val) {
                    setState(() {
                      tipoVehiculo = val!;
                    });
                  },
                ),
                const Text('Moto'),
                Radio(
                  value: 'Automovil',
                  groupValue: tipoVehiculo,
                  onChanged: (val) {
                    setState(() {
                      tipoVehiculo = val!;
                    });
                  },
                ),
                const Text('Automóvil'),
                Radio(
                  value: 'Otro',
                  groupValue: tipoVehiculo,
                  onChanged: (val) {
                    setState(() {
                      tipoVehiculo = val!;
                    });
                  },
                ),
                const Text('Otro'),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Estado de la plaza',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'disponible',
                  groupValue: estado,
                  onChanged: (val) {
                    setState(() {
                      estado = val!;
                    });
                  },
                ),
                const Text('Disponible'),
                Radio(
                  value: 'noDisponible',
                  groupValue: estado,
                  onChanged: (val) {
                    setState(() {
                      estado = val!;
                    });
                  },
                ),
                const Text('No Disponible'),
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> datos = {
                  'nombre': nombreController.text,
                  'tipoVehiculo': tipoVehiculo,
                  'descripcion': descripcionController.text,
                  'estado': estado,
                };
                await editarPlaza(widget.idPlaza, datos);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'Guardar Cambios',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> agregarDocumentoASubcoleccion(
    DocumentReference seccionRef, Map<String, dynamic> datos) async {
  // // Obtén una referencia a la colección principal, en este caso, 'parqueos'
  // CollectionReference parqueos =
  //     FirebaseFirestore.instance.collection('parqueo');
  // // Obtén una referencia al documento del parqueo
  // DocumentReference parqueoDocRef = parqueos.doc("ID-PARQUEO-3");
  // // Obtén una referencia a la subcolección 'pisos' dentro del documento del parqueo
  // CollectionReference pisos = parqueoDocRef.collection('pisos');
  // // Obtén una referencia al documento del piso
  // DocumentReference pisoDocRef = pisos.doc('ID-PISO-1');
  // // Obtén una referencia a la subcolección 'filas' dentro del documento del piso
  // CollectionReference filas = pisoDocRef.collection('filas');
  // // Obtén una referencia al documento de la fila
  // DocumentReference filaDocRef = filas.doc('ID-FILA-1');
  // Obtén una referencia a la subcolección 'plazas' dentro del documento de la fila
  CollectionReference plazasCollection = seccionRef.collection('plazas');
  //datos.addAll({'idParqueo': parqueoDocRef,'idPiso': pisoDocRef,'idFila': filaDocRef});
  // Usa set para agregar el documento con los datos proporcionados
  await plazasCollection.doc().set(datos);
}

Future<void> editarPlaza(
    DocumentReference idPlaza, Map<String, dynamic> datos) async {
  try {
    // Obtén una referencia al documento de la plaza que deseas editar

    DocumentReference plazaRef = idPlaza;
    // Utiliza update para modificar campos existentes o set con merge: true para combinar datos nuevos con los existentes
    await plazaRef.update(
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
        idPlaza: document.reference,
        nombre: data['nombre'],
        estado: data['estado'],
        tipo: data['tipoVehiculo'],
      );
    }).toList();

    return plazas;
  } catch (e) {
    log('Error al obtener las plazas: $e');
    return [];
  }
}

Stream<QuerySnapshot> obtenerPlazasStream(DocumentReference seccionRef) {
  try {
    // DocumentSnapshot<Map<String, dynamic>> plazaDoc = FirebaseFirestore.instance
    //     .collection('parqueo')
    //     .doc('ID-PARQUEO-3') as DocumentSnapshot<Map<String, dynamic>>;
    // DocumentSnapshot<Map<String, dynamic>> plazaDoc =
    //     seccionRef as DocumentSnapshot<Map<String, dynamic>>;
    // if (plazaDoc.exists) {
    //   Map<String, dynamic> data = plazaDoc.data() as Map<String, dynamic>;
    //   String nombre = data['nombre'];
    // }

    CollectionReference plazasCollection = seccionRef.collection('plazas');
    return plazasCollection
        .snapshots(); // Devuelve un Stream que escucha cambios en la colección.
  } catch (e) {
    log('Error al obtener el Stream de plazas: $e');
    rethrow;
  }
}
