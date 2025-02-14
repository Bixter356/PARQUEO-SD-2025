import 'package:cloud_firestore/cloud_firestore.dart';

class Seccion {
  late DocumentReference idSeccion;
  late String name;
  late String description;

  Seccion(this.idSeccion, this.name, this.description);
}
