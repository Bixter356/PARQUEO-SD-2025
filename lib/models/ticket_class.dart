class Ticket {
  late String idTicket;
  late String brand;
  late DateTime date;
  late DateTime dateArrive;
  late DateTime dateOut;
  late String model;
  late String plate;
  late String status;
  late double total;
  late String typeVehicle;

  Ticket({
    required this.idTicket,
    required this.brand,
    required this.date,
    required this.dateArrive,
    required this.dateOut,
    required this.model,
    required this.plate,
    required this.status,
    required this.total,
    required this.typeVehicle,
  });
}
