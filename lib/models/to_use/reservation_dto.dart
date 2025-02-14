class ReservaDTO {
  String idParqueo;
  String idPlaza;
  String idVehiculo;
  String idCliente;
  String estado;
  DateTime fechaLlegada;
  DateTime fechaSalida;
  DateTime fecha;
  double total;

  ReservaDTO({
    required this.idParqueo,
    required this.idPlaza,
    required this.idVehiculo,
    required this.idCliente,
    required this.estado,
    required this.fechaLlegada,
    required this.fechaSalida,
    required this.fecha,
    required this.total,
  });
}