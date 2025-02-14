class Usuario {
  String? id;
  String apellido;
  int cantidadResenias;
  String correo;
  String estado;
  String nombre;
  int puntaje;
  int sumaPuntos;
  int telefono;
  String tipo;

  Usuario({
    required this.apellido,
    required this.cantidadResenias,
    required this.correo,
    required this.estado,
    required this.nombre,
    required this.puntaje,
    required this.sumaPuntos,
    required this.telefono,
    required this.tipo,
    this.id,
  });
}
