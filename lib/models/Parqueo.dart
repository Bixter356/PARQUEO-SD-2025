import 'package:cloud_firestore/cloud_firestore.dart';
//esta clase es auxiliar para el manejo de los parqueos

class Parqueo {

  final String idParqueo;

  final String nombre;

  final String direccion;

  final GeoPoint ubicacion;

  final bool tieneCobertura;

  final String descripcion;

  final Map<String, dynamic> vehiculosPermitidos; //BOOL

  final String nit;

  final Map<String, dynamic> tarifaMoto; //DOUBLE

  final Map<String, dynamic> tarifaAutomovil; //DOUBLE

  final Map<String, dynamic> tarifaOtro; //DOUBLE

  final String horaApertura;

  final String horaCierre;

  final String idDuenio;

  Parqueo(this.idParqueo, this.nombre, this.direccion, this.ubicacion, 
          this.tieneCobertura, this.descripcion, this.vehiculosPermitidos, this.nit, 
          this.tarifaAutomovil, this.tarifaMoto, this.tarifaOtro, this.horaApertura, this.horaCierre, this.idDuenio);

}



class ParqueoPrueba{

  final DocumentReference idParqueo;

  final String nombre;

  final String direccion;

  final GeoPoint ubicacion;

  final bool tieneCobertura;

  final String descripcion;

  final Map<String, dynamic> vehiculosPermitidos; //BOOL

  final String nit;

  final Map<String, dynamic> tarifaMoto; //DOUBLE

  final Map<String, dynamic> tarifaAutomovil; //DOUBLE

  final Map<String, dynamic> tarifaOtro; //DOUBLE

  final String horaApertura;

  final String horaCierre;

  final String idDuenio;

  ParqueoPrueba(this.idParqueo, this.nombre, this.direccion, this.ubicacion, 
          this.tieneCobertura, this.descripcion, this.vehiculosPermitidos, this.nit, 
          this.tarifaAutomovil, this.tarifaMoto, this.tarifaOtro, this.horaApertura, this.horaCierre, this.idDuenio);

}