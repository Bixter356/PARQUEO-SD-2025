// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:parking_project/models/to_use/parking.dart';

// class Reserva {
//   final Map<String, dynamic> cliente;
//   final Map<String, dynamic> parqueo;
//   final Map<String, dynamic> ticket;
//   final Map<String, dynamic> vehiculo;

//   Reserva(this.cliente, this.parqueo, this.ticket, this.vehiculo);
// }

// class CreateReservaScreen extends StatelessWidget {
//   static const routeName = '/vista-reserva';

//   const CreateReservaScreen({super.key});

//   //final String idParqueo;

//   //CreateReservaScreen({required this.idParqueo});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: const Text('Formulario de Reserva'),
//           backgroundColor: const Color.fromARGB(255, 5, 126, 225),
//         ),
//         //body: ReservaListScreen(idParqueo: idParqueo,),
//         body: ReservaListScreen(),
//       ),
//     );
//   }
// }

// class ReservaListScreen extends StatefulWidget {
//   //final String idParqueo;

//   //ReservaListScreen({required this.idParqueo});

//   @override
//   _ReservaListScreenState createState() => _ReservaListScreenState();
// }

// class _ReservaListScreenState extends State<ReservaListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lista de Reservas'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // ... otros widgets ...

//             ElevatedButton(
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => AgregarReservaScreen(),
//                 //   ),
//                 // );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//               ),
//               child: const Text('Agregar Reserva'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AgregarReservaScreen extends StatefulWidget {
//   final DataReservationSearch dataReservationSearch;
//   const AgregarReservaScreen({super.key, required this.dataReservationSearch});

//   @override
//   AgregarReservaScreenState createState() => AgregarReservaScreenState();
// }

// class AgregarReservaScreenState extends State<AgregarReservaScreen> {
//   String vehiculoSeleccionado = 'Autos';
//   String coberturaSeleccionada = 'SI';
//   TextEditingController idParqueoController = TextEditingController();
//   TextEditingController idPisoController = TextEditingController();
//   TextEditingController idFilaController = TextEditingController();
//   TextEditingController vehiculoPermitidoController = TextEditingController();
//   TextEditingController placaVehiculoController = TextEditingController();
//   TextEditingController marcaVehiculoController = TextEditingController();
//   TextEditingController colorVehiculoController = TextEditingController();
//   TextEditingController modeloVehiculoController = TextEditingController();
//   TextEditingController cuentaCoberturaController = TextEditingController();
//   TextEditingController fechaLlegadaController = TextEditingController();
//   TextEditingController horaLlegadaController = TextEditingController();
//   TextEditingController fechaSalidaController = TextEditingController();
//   TextEditingController horaSalidaController = TextEditingController();
//   TextEditingController precioTotalController = TextEditingController();

//   Map<String, dynamic>? cliente;
//   Map<String, dynamic>? parqueo;
//   Map<String, dynamic>? ticket;
//   Map<String, dynamic>? vehiculo;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Realizar Reserva'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text("ID del Parqueo"),
//             TextFormField(
//               controller: idParqueoController,
//               decoration: const InputDecoration(
//                 hintText: "Ingrese el ID del Parqueo",
//               ),
//             ),
//             const SizedBox(height: 20.0),

//             const Text("ID del Piso"),
//             TextFormField(
//               controller: idPisoController,
//               decoration: const InputDecoration(
//                 hintText: "Ingrese el ID del Piso",
//               ),
//             ),
//             const SizedBox(height: 20.0),

//             const Text("ID de la Fila"),
//             TextFormField(
//               controller: idFilaController,
//               decoration: const InputDecoration(
//                 hintText: "Ingrese el ID de la Fila",
//               ),
//             ),
//             const SizedBox(height: 20.0),

//             Container(
//               color: Colors.grey[200],
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Tipo de Vehículo:"),
//                   Row(
//                     children: [
//                       Radio(
//                         value: 'Autos',
//                         groupValue: vehiculoSeleccionado,
//                         onChanged: (value) {
//                           setState(() {
//                             vehiculoSeleccionado = value as String;
//                           });
//                         },
//                       ),
//                       const Text('Autos'),
//                       Radio(
//                         value: 'Motos',
//                         groupValue: vehiculoSeleccionado,
//                         onChanged: (value) {
//                           setState(() {
//                             vehiculoSeleccionado = value as String;
//                           });
//                         },
//                       ),
//                       const Text('Motos'),
//                       Radio(
//                         value: 'Mixto',
//                         groupValue: vehiculoSeleccionado,
//                         onChanged: (value) {
//                           setState(() {
//                             vehiculoSeleccionado = value as String;
//                           });
//                         },
//                       ),
//                       const Text('Mixto'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Grupo de entradas de texto para Placa, Marca, Color y Modelo
//             Container(
//               color: Colors.grey[200],
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text("Placa:"),
//                   TextFormField(
//                     controller: placaVehiculoController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese la placa",
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Text("Marca:"),
//                   TextFormField(
//                     controller: marcaVehiculoController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese la marca",
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Text("Color:"),
//                   TextFormField(
//                     controller: colorVehiculoController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese el color",
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Text("Modelo:"),
//                   TextFormField(
//                     controller: modeloVehiculoController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese el modelo",
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Grupo de radio buttons para Cobertura
//             Container(
//               color: Colors.grey[200],
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Cuenta con cobertura:"),
//                   Row(
//                     children: [
//                       Radio(
//                         value: 'SI',
//                         groupValue: coberturaSeleccionada,
//                         onChanged: (value) {
//                           setState(() {
//                             coberturaSeleccionada = value as String;
//                           });
//                         },
//                       ),
//                       const Text('SI'),
//                       Radio(
//                         value: 'NO',
//                         groupValue: coberturaSeleccionada,
//                         onChanged: (value) {
//                           setState(() {
//                             coberturaSeleccionada = value as String;
//                           });
//                         },
//                       ),
//                       const Text('NO'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Grupo de entradas de texto para Fecha y Hora de Llegada y Salida
//             Container(
//               color: Colors.grey[200],
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text("Fecha de Llegada:"),
//                   TextFormField(
//                     controller: fechaLlegadaController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese la fecha de llegada",
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Text("Hora de Llegada:"),
//                   TextFormField(
//                     controller: horaLlegadaController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese la hora de llegada",
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Text("Fecha de Salida:"),
//                   TextFormField(
//                     controller: fechaSalidaController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese la fecha de salida",
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   const Text("Hora de Salida:"),
//                   TextFormField(
//                     controller: horaSalidaController,
//                     decoration: const InputDecoration(
//                       hintText: "Ingrese la hora de salida",
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Texto de Precio Total
//             Container(
//               color: Colors.grey[200],
//               padding: const EdgeInsets.all(16.0),
//               child: const Center(
//                 child: Text("Precio total: 90 Bs."),
//               ),
//             ),

//             // Agrega más campos para los datos de la reserva según tu clase Reserva

//             ElevatedButton(
//               onPressed: () async {
//                 // Aquí puedes implementar la lógica para agregar una nueva reserva
//                 // utilizando los datos ingresados en los controladores.
//                 Map<String, dynamic> data = {
//                   'idParqueo': idParqueoController.text,
//                   'idPiso': idPisoController.text,
//                   'idFila': idFilaController.text,
//                   'vehiculoPermitido': vehiculoPermitidoController.text,
//                   'placaVehiculo': placaVehiculoController.text,
//                   'marcaVehiculo': marcaVehiculoController.text,
//                   'colorVehiculo': colorVehiculoController.text,
//                   'modeloVehiculo': modeloVehiculoController.text,
//                   'cuentaCobertura': coberturaSeleccionada,
//                   'fechaLlegada': fechaLlegadaController.text,
//                   'horaLlegada': horaLlegadaController.text,
//                   'fechaSalida': fechaSalidaController.text,
//                   'horaSalida': horaSalidaController.text,
//                   'precioTotal': precioTotalController.text,
//                 };

//                 await agregarReserva(data);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//               ),
//               child: const Text('Reservar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Future<void> agregarReserva(Map<String, dynamic> datos) async {
//   // Obtén una referencia a la colección principal, en este caso, 'parqueos'

//   CollectionReference reserva =
//       FirebaseFirestore.instance.collection('reserva');

//   // Obtén una referencia al documento del parqueo

//   await reserva.doc().set(datos);
// }
