import 'package:flutter/material.dart';
import 'package:parking_project/pages/client/reservas_realizadas/reservas_activas.dart';
import 'package:parking_project/pages/client/reservas_realizadas/reservas_pendientes.dart';
import 'package:parking_project/pages/client/reservation/nearby_parking.dart';
import 'package:parking_project/pages/map/map_client.dart';

class HomeClient extends StatelessWidget {
  const HomeClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 700,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              child: Container(
                color: const Color.fromARGB(255, 2, 51, 91),
                height: 250,
                child: Center(
                    child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Bienvenido User',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Image.asset(
                      'assets/logo.png',
                      width: 150,
                      height: 100,
                    ),
                    const Text(
                      'PROJECT PARK',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                )),
              ),
            ),
            Positioned(
              top: 190,
              left: 0,
              right: 0,
              child: Card(
                elevation: 4,
                borderOnForeground: true,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 135,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.file_open_rounded),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SelectParkingScreen()));
                              
                              
                              //SelectParkingScreen
                              // Agrega la lógica para el botón 'Mis parqueos' aquí
                            },
                            iconSize: 50,
                            color: const Color.fromARGB(255, 3, 53, 94),
                          ),
                          const Text(
                            'Nueva Reserva',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      Column(children: [
                        IconButton(
                          icon: const Icon(Icons.assignment_rounded),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ReservasActivasCliente()));
                            // Agrega la lógica para el botón 'Reservas solicitadas' aquí
                          },
                          iconSize: 50,
                          color: const Color.fromARGB(255, 4, 47, 82),
                        ),
                        const Text(
                          'Reservas Activas',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],),
                    ],
                  )
                  ,
                ),
              ),
            ),
            Positioned(
              top: 340,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapClient()));
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 40,
                          color: Colors.green,
                        ),
                      Text(
                            "Buscar Parqueos",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          
            Positioned(
              top: 480,
              left: 0,
              right: 0,
              child: Card(
                elevation: 4,
                borderOnForeground: true,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 135,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.file_open_rounded),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ReservasPendientesCliente()));
                              //SelectParkingScreen
                              // Agrega la lógica para el botón 'Mis parqueos' aquí
                            },
                            iconSize: 50,
                            color: const Color.fromARGB(255, 3, 53, 94),
                          ),
                          const Text(
                            'Reservas Pendientes',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),],
                  )
                  ,
                ),
              ),
            ),
            
          
          
          ],
        ),
      ),
    );
  }
}
