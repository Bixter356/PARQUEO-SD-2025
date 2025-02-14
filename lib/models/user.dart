class UserData {
  final String nombre;
  final String apellidos;
  final int telefono;
  final String correoElectronico;
  final String contrasena;
  final String genero;
  String typeUser;
  String id;
  UserData(
      {required this.nombre,
      required this.apellidos,
      required this.telefono,
      required this.correoElectronico,
      required this.contrasena,
      required this.genero,
      this.typeUser = '',
      this.id = ''});
}
