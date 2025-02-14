class UserTransition {
  final String nombre;
  final String apellidos;
  final int telefono;
  final String correoElectronico;
  final String contrasena;
  final String genero;
  String typeUser;
  UserTransition(
      {required this.nombre,
      required this.apellidos,
      required this.telefono,
      required this.correoElectronico,
      required this.contrasena,
      required this.genero,
      this.typeUser = ''});
}