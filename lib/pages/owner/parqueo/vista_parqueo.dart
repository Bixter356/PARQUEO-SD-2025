import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:parking_project/helpers/extensions.dart';
import 'package:parking_project/models/to_use/parking.dart';
import 'package:parking_project/routes/routes.dart';

class Plaza {

  final String nombre;

  final bool tieneCobertura;

  final String idPlaza;

  Plaza(this.nombre, this.tieneCobertura,this.idPlaza);

}

class CreateParqueoScreen extends StatelessWidget {

  static const routeName = '/vista-parqueo';
  const CreateParqueoScreen({super.key});

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

        appBar: AppBar(

          title: const Text('Formulario de Parqueo'),

          backgroundColor: const Color.fromARGB(255, 5, 126, 225),

        ),

        body: const ParqueoListScreen(),

      ),

    );

  }

}
class ParqueoListScreen extends StatefulWidget {

  const ParqueoListScreen({super.key});

 

  @override

  ParqueoListScreenState createState() => ParqueoListScreenState();

}

 

class ParqueoListScreenState extends State<ParqueoListScreen> {

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Parqueos'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(       
        stream: obtenerParqueosStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {

            return Text('Error: ${snapshot.error}');

          }

          // Obtén la lista de Parqueos

            List<Parqueo> parqueos =

                snapshot.data!.docs.map((DocumentSnapshot document) {

              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              //String idDocumento = document.id; // Obtener el ID del documento
              return Parqueo(idParqueo: document.reference,nombre: data['nombre'],direccion: data['direccion'],ubicacion: data['ubicacion'],
                             descripcion: data['descripcion'],vehiculosPermitidos: data['vehiculosPermitidos'], puntaje: data['puntaje'],diasApertura: data['diasApertura'],
                             tarifaMoto:data['tarifaMoto'],tarifaAutomovil: data['tarifaAutomovil'],tarifaOtro: data['tarifaOtro'], 
                             horaApertura:data['horaApertura'],horaCierre: data['horaCierre'],idDuenio: data['idDuenio']);
                              


            }).toList();
          return ListView.builder(
            itemCount: parqueos.length,
            itemBuilder: (context, index) {
              final parqueo = parqueos[index];
              return InkWell(
                onTap: () {
                  // Aquí puedes definir la acción que se realizará al hacer clic en el elemento.
                  // Por ejemplo, puedes abrir una pantalla de detalles de la plaza.
                  //abrirDetallesPlaza(plaza);
                  context.pushNamedAndRemoveUntil(
                    Routes.registerPlaceScreen,
                    predicate: (route) => false,
                    arguments: [parqueo.idParqueo],
                  );

                },   

                child: ListTile(

                  title: Text(parqueo.nombre),

                  // subtitle: Text(
                  //     parqueo.tieneCobertura ? 'Con Cobertura' : 'Sin Cobertura'),
                  trailing: Row(

                    mainAxisSize: MainAxisSize.min,

                    children: [

                      IconButton(

                        icon: const Icon(Icons.edit),

                        onPressed: () {

                          // Implementa aquí la lógica para abrir la pantalla de edición.

                          // Navigator.push(

                          //   context,

                          //   MaterialPageRoute(

                          //     builder: (context) => EditarParqueoScreen(idParqueo:parqueo.idParqueo),

                          //   ),

                          // );

                        },

                      ),

                    ],

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

            MaterialPageRoute(builder: (context) => const AgregarParqueoScreen()),

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

 

class AgregarParqueoScreen extends StatefulWidget {
  const AgregarParqueoScreen({super.key});


  @override

  _AgregarParqueoScreen createState() => _AgregarParqueoScreen();

}

 

class _AgregarParqueoScreen extends State<AgregarParqueoScreen> {

 TextEditingController nombreController = TextEditingController();

 TextEditingController direccionController = TextEditingController();

 TextEditingController latitudController = TextEditingController();

 TextEditingController longitudController = TextEditingController();

 bool? tieneCoberturaController;

 TextEditingController descripcionController = TextEditingController();

 Map<String, bool>? vehiculosPermitidosController;

 TextEditingController nitController = TextEditingController();

 Map<String, double>? tarifaMotoController;

 Map<String, double>? tarifaAutomovilController;

 Map<String, double>? tarifaOtroController;

 TextEditingController horaAperturaController = TextEditingController();

 TextEditingController horaCierreController = TextEditingController();
 
 TextEditingController motoHoraController = TextEditingController();
 TextEditingController motoDiaController = TextEditingController();
 TextEditingController automovilHoraController = TextEditingController();
 TextEditingController automovilDiaController = TextEditingController();
 TextEditingController otroHoraController = TextEditingController();
 TextEditingController otroDiaController = TextEditingController();

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('Agregar Nuevo Parqueo'),

        backgroundColor: Colors.blue,

      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Input de texto para el nombre del parqueo
            const Text("1. Nombre del Parqueo"),
            
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(
                hintText: "Ingrese el nombre del parqueo",
              ),
            ),
            const SizedBox(height: 20.0),

            // Input de texto para la dirección del parqueo
            const Text("2. Dirección del Parqueo"),
            TextFormField(
              controller: direccionController,
              decoration: const InputDecoration(
                hintText: "Ingrese la dirección del parqueo",
              ),
            ),
            const SizedBox(height: 20.0),

            // Input de texto para la latitud y longitud
            const Text("3. Coordenadas"),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: latitudController,
                    decoration: const InputDecoration(
                      hintText: "Latitud",
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    controller: longitudController,
                    decoration: const InputDecoration(
                      hintText: "Longitud",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Switch para "Cuenta con cubierta"
            const Text("4. Cuenta con cubierta"),
            Row(
              children: [
                const Text("No"),
                Switch(
                  value: true,
                  onChanged: (value) {
                    setState(() {
                      //vehiculoSeleccionado = value ? "Sí" : "No";
                    });
                  },
                ),
                const Text("Sí"),
              ],
            ),
            const SizedBox(height: 20.0),

            // Input de texto grande para la descripción del parqueo
            const Text("5. Descripción del Parqueo"),
            TextFormField(
              controller: descripcionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Ingrese la descripción del parqueo",
              ),
            ),
            const SizedBox(height: 20.0),

            // Título "Vehículos permitidos"
            const Text("6. Vehículos permitidos"),
            //Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //  children: [
            //    Radio(
            //      value: "Autos",
            //      groupValue: vehiculoSeleccionado,
            //      onChanged: (value) {
            //        setState(() {
            //          vehiculoSeleccionado = value;
            //        });
            //      },
            //    ),
            //    Text("Autos"),
            //    Radio(
            //      value: "Motos",
            //      groupValue: vehiculoSeleccionado,
            //      onChanged: (value) {
            //        setState(() {
            //          vehiculoSeleccionado = value;
            //        });
            //      },
            //    ),
            //    Text("Motos"),
            //    Radio(
            //      value: "Mixto",
            //      groupValue: vehiculoSeleccionado,
            //      onChanged: (value) {
            //        setState(() {
            //          vehiculoSeleccionado = value;
            //        });
            //      },
            //    ),
            //    Text("Mixto"),
            //  ],
            //),
            const SizedBox(height: 20.0),

            // Input de texto para el NIT del propietario
            const Text("7. NIT del Propietario"),
            TextFormField(
              controller: nitController,
              decoration: const InputDecoration(
                hintText: "Ingrese el NIT del propietario",
              ),
            ),
            const SizedBox(height: 20.0),

            // Tarifas de auto y moto
            const Text("8. Tarifas"),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Autos: hora/"),
                      TextFormField(
                        controller: automovilHoraController,
                        decoration: const InputDecoration(
                          hintText: "Ingrese tarifa por hora",
                        ),
                      ),
                      const Text("Bs. - día/"),
                      TextFormField(
                        controller: automovilDiaController,
                        decoration: const InputDecoration(
                          hintText: "Ingrese tarifa por día",
                        ),
                      ),
                      const Text("Bs."),
                    ],
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Motos: hora/"),
                      TextFormField(
                        controller: motoHoraController,
                        decoration: const InputDecoration(
                          hintText: "Ingrese tarifa por hora",
                        ),
                      ),
                      const Text("Bs. - día/"),
                      TextFormField(
                        controller: motoDiaController,
                        decoration: const InputDecoration(
                          hintText: "Ingrese tarifa por día",
                        ),
                      ),
                      const Text("Bs."),
                    ],
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Otros: hora/"),
                      TextFormField(
                        controller: otroHoraController,
                        decoration: const InputDecoration(
                          hintText: "Ingrese tarifa por hora",
                        ),
                      ),
                      const Text("Bs. - día/"),
                      TextFormField(
                        controller: otroDiaController,
                        decoration: const InputDecoration(
                          hintText: "Ingrese tarifa por día",
                        ),
                      ),
                      const Text("Bs."),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Input de texto para la hora de apertura y cierre
            const Text("9. Horario de Apertura y Cierre"),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: horaAperturaController,
                    decoration: const InputDecoration(
                      hintText: "Hora de Apertura",
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    controller: horaCierreController,
                    decoration: const InputDecoration(
                      hintText: "Hora de Cierre",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async{
                GeoPoint ubicacion = GeoPoint(double.parse(latitudController.text), double.parse(longitudController.text));
                Map<String, bool> vhp = {'Autos': true, 'Motos': true, 'Otros':false};
                Map<String,double> tarifaMoto = {'Dia': double.parse(motoDiaController.text), 'Hora':double.parse(motoHoraController.text)};
                Map<String,double> tarifaAutomovil = {'Dia': double.parse(automovilDiaController.text), 'Hora':double.parse(automovilHoraController.text)};
                Map<String,double> tarifaOtro = {'Dia': double.parse(otroDiaController.text), 'Hora':double.parse(otroHoraController.text)};
                Map<String, dynamic> data = {
                  'nombre': nombreController.text,
                  'direccion' : direccionController.text,
                  'ubicacion': ubicacion,
                  'tieneCobertura': true,
                  'descripcion': descripcionController.text, 
                  'vehiculosPermitidos': vhp , 
                  'nit': nitController.text,
                  'tarifaMoto': tarifaMoto, 
                  'tarifaAutomovil': tarifaAutomovil, 
                  'tarifaOtro': tarifaOtro, 
                  'horaApertura': horaAperturaController.text, 
                  'horaCierre': horaCierreController.text, 
                  'idDuenio': 'DoxhZory2ye1bg0R5XxzoyePMMX2'
                };
              

                await agregarParqueo(data);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 23, 131, 255), // Color del texto en blanco
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
      );

  }

}

 

// class EditarParqueoScreen extends StatefulWidget {

//   final DocumentReference idParqueo; // Recibe el ID de la plaza

//   const EditarParqueoScreen({super.key, required this.idParqueo});

 

//   @override

//   EditarParqueoScreenState createState() => EditarParqueoScreenState();

// }

 

// class EditarParqueoScreenState extends State<EditarParqueoScreen> {

//   TextEditingController nombreController = TextEditingController();

//   TextEditingController pisoYFilaController = TextEditingController();

 

//   String tipoVehiculo = '';

//   bool tieneCobertura = false;

 

//   @override

//   void initState() {

//     super.initState();

//     cargarDatosPlaza(); // Carga los datos de la plaza en initState

//   }

 

//   Future<void> cargarDatosPlaza() async {

//     try {

//       // Usa el ID de la plaza para obtener los datos desde Firestore

//       DocumentSnapshot<Map<String, dynamic>> plazaDoc = await FirebaseFirestore

//           .instance

//           .collection('parqueo')

//           .doc('ID-PARQUEO-3')

//           .collection('pisos')

//           .doc('ID-PISO-1')

//           .collection('filas')

//           .doc('ID-FILA-1')

//           .collection('plazas')

//           .doc(widget.idParqueo) // Usa el ID de la plaza pasado como argumento

//           .get();

 

//       if (plazaDoc.exists) {

//         Map<String, dynamic> data = plazaDoc.data() as Map<String, dynamic>;

//         setState(() {

//           nombreController.text = data['nombre'];

//           tipoVehiculo = data['tipoVehiculo'];

//           tieneCobertura = data['tieneCobertura'];

//           pisoYFilaController.text = data['piso_fila'];

//         });

//       }

//     } catch (e) {

//       log('Error al cargar los datos de la plaza: $e');

//     }

//   }

 

//   @override

//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(

//         title: const Text('Editar Plaza'),

//         backgroundColor: Colors.blue,

//       ),

//       body: Padding(

//         padding: const EdgeInsets.all(16.0),

//         child: Column(

//           crossAxisAlignment: CrossAxisAlignment.center,

//           children: <Widget>[

//             TextFormField(

//               controller: nombreController,

//               decoration: const InputDecoration(

//                 labelText: 'Nombre',

//                 fillColor: Colors.blue,

//                 focusedBorder: OutlineInputBorder(

//                   borderSide: BorderSide(color: Colors.blue, width: 2.0),

//                 ),

//               ),// Establece el valor inicial desde Firestore

//             ),

//             const SizedBox(height: 20.0),

//             Container(

//               alignment: Alignment.topLeft,

//               child: const Text(

//                 'Tipo de Vehículo',

//                 style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),

//               ),

//             ),

//             Row(

//               children: <Widget>[

//                 Radio(

//                   value: 'Moto',

//                   groupValue: tipoVehiculo,

//                   onChanged: (val) {

//                     setState(() {

//                       tipoVehiculo = val!;

//                     });

//                   },

//                 ),

//                 const Text('Moto'),

//                 Radio(

//                   value: 'Automóvil',

//                   groupValue: tipoVehiculo,

//                   onChanged: (val) {

//                     setState(() {

//                       tipoVehiculo = val!;

//                     });

//                   },

//                 ),

//                 const Text('Automóvil'),

//                 Radio(

//                   value: 'Otro',

//                   groupValue: tipoVehiculo,

//                   onChanged: (val) {

//                     setState(() {

//                       tipoVehiculo = val!;

//                     });

//                   },

//                 ),

//                 const Text('Otro'),

//               ],

//             ),

//             const SizedBox(height: 20.0),

//             Container(

//                 alignment: Alignment.topLeft,

//                 child: const Text('¿Tiene Cobertura?',

//                     style: TextStyle(

//                         fontSize: 16.0, fontWeight: FontWeight.bold))),

//             Row(

//               children: <Widget>[

//                 Radio(

//                   value: true,

//                   groupValue: tieneCobertura,

//                   onChanged: (val) {

//                     setState(() {

//                       tieneCobertura = val!;

//                     });

//                   },

//                 ),

//                 const Text('Sí'),

//                 Radio(

//                   value: false,

//                   groupValue: tieneCobertura,

//                   onChanged: (val) {

//                     setState(() {

//                       tieneCobertura = val!;

//                     });

//                   },

//                 ),

//                 const Text('No'),

//               ],

//             ),

//             const SizedBox(height: 20.0),

//             TextFormField(

//               controller: pisoYFilaController,

//               decoration: const InputDecoration(

//                 labelText: 'Piso y Fila',

//                 fillColor: Colors.blue,

//                 focusedBorder: OutlineInputBorder(

//                   borderSide: BorderSide(color: Colors.blue, width: 2.0),

//                 ),

//               ) // Establece el valor inicial desde Firestore

//             ),

//             const SizedBox(height: 20.0),

//             ElevatedButton(

//               onPressed: () async {

//                 Map<String, dynamic> datos = {

//                   'nombre': nombreController.text, // Nombre de la plaza

//                   'tipoVehiculo': tipoVehiculo, // Tipo de vehículo permitido

//                   'tieneCobertura':

//                       tieneCobertura, // Indica si tiene cobertura o no

//                   'piso_Fila': pisoYFilaController.text, // Piso y Fila

//                   // Puedes agregar otros campos según tus necesidades

//                 };

//                 // Llama a la función para actualizar el documento en Firestore

//                 await editarPlaza(

//                     'ID-PARQUEO-3',

//                     'ID-PISO-1',

//                     'ID-FILA-1',

//                     widget.idParqueo,

//                     datos); // Usa el ID de la plaza pasado como argumento

//                 // Regresa a la pantalla anterior con los datos actualizados

//                 Navigator.pop(

//                   context //Se puede enviar Un objeto plaza

//                 );

//               },

//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

//               child: const Text('Guardar Cambios'),

//             ),

//           ],

//         ),

//       ),

//     );

//   }

// }


Future<void> agregarParqueo(Map<String, dynamic> datos) async {

  // Obtén una referencia a la colección principal, en este caso, 'parqueos'

  CollectionReference parqueos =

      FirebaseFirestore.instance.collection('parqueo');

  // Obtén una referencia al documento del parqueo
  

  
  await parqueos.doc().set(datos);

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

    await plazaDocRef.update(datos); // Utiliza update para modificar campos existentes o set con merge: true

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

      return Plaza(data['nombre'], data['tieneCobertura'],document.id);

    }).toList();

 

    return plazas;

  } catch (e) {

    log('Error al obtener las plazas: $e');

    return [];

  }

}

 

Stream<QuerySnapshot> obtenerParqueosStream() {

  try {

    CollectionReference parqueosCollection = FirebaseFirestore.instance
        .collection('parqueo');

    return parqueosCollection

        .snapshots(); // Devuelve un Stream que escucha cambios en la colección.

  } catch (e) {

    log('Error al obtener el Stream de plazas: $e');

    rethrow;

  }

}

 

