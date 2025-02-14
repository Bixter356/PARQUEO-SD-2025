
class VehicleData {
  final String placa;
  final String color;
  final String marca;
  final String tipo;
  final double alto;
  final double ancho;
  final double largo;



  final String idCliente;
  final String id;
  
  VehicleData(
      {required this.placa,
      required this.color,
      required this.marca,
      required this.tipo,
      required this.alto,
      required this.ancho,
      required this.largo,

      this.idCliente = '',
      this.id = ''
     });
}
