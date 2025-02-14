import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/models/to_use/reservation_request.dart';

class ReservaRequestScreen extends StatelessWidget {
  final Reserva reserva;

  const ReservaRequestScreen({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    TextEditingController totalController = TextEditingController(text: reserva.total.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Pendientes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha: ${reserva.date}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fecha de llegada: ${reserva.dateArrive}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fecha de salida: ${reserva.dateOut}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Modelo: ${reserva.model}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Placa: ${reserva.plate}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Estado: ${reserva.status}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: totalController,
                decoration: const InputDecoration(
                  labelText: 'Total',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Tipo de vehículo: ${reserva.typeVehicle}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String id = reserva.id;
                      //obtener el documento de la coleccion reserva
                      DocumentReference reservaRef = FirebaseFirestore.instance.collection('reserva').doc(id);
                      //actualizar el estado de la reserva
                      reservaRef.update({'estado': 'activo', 'total': double.parse(totalController.text)});

                      Navigator.pop(context);
                    },
                    child: const Text('Aceptar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String id = reserva.id;
                      //obtener el documento de la coleccion reserva
                      DocumentReference reservaRef = FirebaseFirestore.instance.collection('reserva').doc(id);
                      //actualizar el estado de la reserva
                      reservaRef.update({'estado': 'rechazado'});
                      Navigator.pop(context);
                    },
                    child: const Text('Rechazar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
