

import 'package:cloud_firestore/cloud_firestore.dart';

class Plaza {
  final DocumentReference idPlaza;
  String nombre;
  String tipo;
  String estado;
  Plaza({
    required this.idPlaza,
    required this.nombre,
    required this.estado,
    required this.tipo,
  });
}

class Parqueo {
  final DocumentReference idParqueo;
  String nombre;
  String direccion;
  final GeoPoint ubicacion;
  String descripcion;
  final Map<String, dynamic> vehiculosPermitidos; // BOOL
  Map<String, dynamic> tarifaMoto; // DOUBLE
  Map<String, dynamic> tarifaAutomovil; // DOUBLE
  Map<String, dynamic> tarifaOtro; // DOUBLE
  List<dynamic> diasApertura; // DOUBLE
  Timestamp horaApertura;
  Timestamp horaCierre;
  final String idDuenio;
  double puntaje;
  List<Plaza> plaza;
  String? foto;

  Parqueo({
    required this.idParqueo,
    required this.nombre,
    required this.direccion,
    required this.ubicacion,
    required this.descripcion,
    required this.puntaje,
    required this.vehiculosPermitidos,
    required this.diasApertura,
    required this.tarifaAutomovil,
    required this.tarifaMoto,
    required this.tarifaOtro,
    required this.horaApertura,
    required this.horaCierre,
    required this.idDuenio,
    List<Plaza>? plaza, // Parámetro con nombre para filas, opcional
    this.foto,
  }) : plaza = plaza ??
            <Plaza>[]; // Inicializa con una lista vacía si no se proporciona
}

class DataReservationSearch {
  String? idVehiculo;
  DocumentReference idParqueo;
  String? parqueo;
  String? plaza;
  String? tipoVehiculo;
  Timestamp? fechaInicio;
  Timestamp? fechaFin;
  double? total;
  DocumentReference? idPlaza;

  String? idDuenio;
  DataReservationSearch(
      {required this.idParqueo,
      this.parqueo,
      this.plaza,
      this.tipoVehiculo,
      this.fechaFin,
      this.fechaInicio,
      this.total,
      this.idPlaza,
      this.idVehiculo,
      this.idDuenio});
}

class ParkingReservation {
  String parqueo;
  bool tieneCobertura;
  String plaza;
  final String tipoVehiculo; // BOOL

  ParkingReservation(
      {required this.parqueo,
      required this.tieneCobertura,
      required this.plaza,
      required this.tipoVehiculo});
}

class VehicleReservation {
  String color;
  String placa;
  String marca;
  String tipo;

  VehicleReservation(
      {required this.color,
      required this.placa,
      required this.marca,
      required this.tipo});
}

class Vehiculo{
  DocumentReference idCliente;
  String placa;
  String marca;
  String color;
  String tipo;
  Vehiculo({
    required this.idCliente,
    required this.placa,
    required this.marca,
    required this.color,
    required this.tipo,
  });

}

class CustomerReservation {
  String nombre;
  String apellidos;
  String celular;
  String correo;

  CustomerReservation({
    required this.nombre,
    required this.apellidos,
    required this.celular,
    required this.correo,
  });
}




// Future<Parqueo> obtenerParqueoDesdeFirestore(String idParqueo) async {
//   DocumentSnapshot parqueoDocument =
//       await FirebaseFirestore.instance.collection('parqueos').doc(idParqueo).get();

//   if (parqueoDocument.exists) {
//     // Obtener los datos principales del documento Parqueo
//     Map<String, dynamic> parqueoData = parqueoDocument.data() as Map<String, dynamic>;

//     // Crear un objeto Parqueo con los datos principales
//     Parqueo parqueo = Parqueo(
//       nombre: parqueoData['nombre'],
//       latitud: parqueoData['latitud'],
//       longitud: parqueoData['longitud'],
//       horaApertura: parqueoData['horaApertura'],
//       horaCierre: parqueoData['horaCierre'],
//       nit: parqueoData['nit'],
//       descripcion: parqueoData['descripcion'],
//       idDueño: parqueoData['idDueño'],
//     );

//     // Obtener la subcolección de Pisos
//     QuerySnapshot pisosSnapshot = await parqueoDocument.reference.collection('pisos').get();

//     // Recorrer los documentos de Pisos y agregarlos al objeto Parqueo
//     for (QueryDocumentSnapshot pisoDocument in pisosSnapshot.docs) {
//       Piso piso = Piso(
//         nombre: pisoDocument['nombre'],
//         idParqueo: pisoDocument['idParqueo'],
//       );

//       // Obtener la subcolección de Filas para este Piso
//       QuerySnapshot filasSnapshot =
//           await pisoDocument.reference.collection('filas').get();

//       // Recorrer los documentos de Filas y agregarlos al objeto Piso
//       for (QueryDocumentSnapshot filaDocument in filasSnapshot.docs) {
//         Fila fila = Fila(
//           nombre: filaDocument['nombre'],
//           idPiso: filaDocument['idPiso'],
//         );

//         // Obtener la subcolección de Plazas para esta Fila
//         QuerySnapshot plazasSnapshot =
//             await filaDocument.reference.collection('plazas').get();

//         // Recorrer los documentos de Plazas y agregarlos al objeto Fila
//         for (QueryDocumentSnapshot plazaDocument in plazasSnapshot.docs) {
//           Plaza plaza = Plaza(
//             nombre: plazaDocument['nombre'],
//             horaApertura: plazaDocument['horaApertura'],
//             horaCierre: plazaDocument['horaCierre'],
//             idPiso: plazaDocument['idPiso'],
//           );

//           fila.plazas.add(plaza);
//         }

//         piso.filas.add(fila);
//       }

//       parqueo.pisos.add(piso);
//     }

//     return parqueo;
//   } else {
//     throw Exception('El parqueo con ID $idParqueo no existe.');
//   }
// }


// class Usuario {
//   String id;
//   String nombre;
//   String tipo; // 'dueño' o 'cliente'
//   // Otros campos de usuario
// }

// class Parqueo {
//   String id;
//   String nombre;
//   double latitud;
//   double longitud;
//   String horaApertura;
//   String horaCierre;
//   String nit;
//   String descripcion;
//   List<Tarifa> tarifas;
//   List<Piso> pisos;
// }

// class Tarifa {
//   double precioHora;
//   double precioDia;
//   String tipoVehiculo;
// }

// class Piso {
//   String nombre;
//   String descripcion;
//   List<Fila> filas;
// }

// class Fila {
//   late String nombre;
//   late String descripcion;
//   late List<Plaza> plazas;
// }

// class Plaza {
//   late String nombre;
//   late String tipoVehiculo;
//   late bool tieneCobertura;
// }

// class Reserva {
//   late String clienteId;
//   late String parqueoId;
//   late DateTime fechaHoraInicio;
//   late DateTime fechaHoraFin;
//   late String plazaReservada;
//   late String estado;
//   // Otros campos de reserva
// }

