import 'package:flutter/material.dart';
import 'package:parking_project/pages/admin/Reportes/calculo_total.dart';
import 'package:parking_project/pages/admin/Reportes/reporte_reserva.dart';
import 'package:parking_project/pages/admin/Reportes/top.dart';
import 'package:parking_project/pages/admin/Reportes/top_clientes_reservas.dart';
import 'package:parking_project/pages/admin/Reportes/top_parqueos_reservas.dart';
import 'package:parking_project/pages/admin/Reportes/top_rechazos_cliente.dart';
import 'package:parking_project/pages/admin/Reportes/top_rechazos_duenio.dart';
class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 900,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              child: Container(
                color: const Color.fromARGB(255, 4, 22, 87),
              height: 270,
                child: Center(
                    child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Bienvenido Administrador',
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
              top: 210,
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
                            icon: const Icon(Icons.arrow_upward_rounded),
                            onPressed: () {
                
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MyHomePage()),
                              );
                            },
                            iconSize: 50,
                            color: const Color.fromARGB(255, 4, 66, 124),
                          ),
                          const Text(
                            'Raking',
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
                              MaterialPageRoute(builder: (context) => ReportScreenTotal()),
                            );
                          },
                          iconSize: 50,
                          color: const Color.fromARGB(255, 3, 65, 116),
                        ),
                        const Text(
                          'Promedio Gasto',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ),


            Positioned(
              top: 360,
              left: 0,
              right: 0,
              child: Card(
                elevation: 4,
                borderOnForeground: true,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 145,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReportScreenRankingReserves()),
                              );
                            },
                            iconSize: 50,
                            color: const Color.fromARGB(255, 4, 66, 124),
                          ),
                          const Text(
                            'Cliente con',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'más reservas',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      Column(children: [
                        IconButton(
                          icon: const Icon(Icons.garage),
                          onPressed: () {
                            // Agrega la lógica para el botón 'Reservas solicitadas' aquí
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReportScreenParkingReserves()),
                            );
                          },
                          iconSize: 50,
                          color: const Color.fromARGB(255, 3, 65, 116),
                        ),
                        const Text(
                          'Parqueos con',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'más reservas',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            


            Positioned(
              top: 530,
              left: 0,
              right: 0,
              child: Card(
                elevation: 4,
                borderOnForeground: true,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 145,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.file_open_rounded),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const SelectParkingScreen()));
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReportScreenRejectOwner()),
                              );
                            },
                            iconSize: 50,
                            color: const Color.fromARGB(255, 4, 66, 124),
                          ),
                          const Text(
                            'Rechazos de',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'Dueño',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      Column(children: [
                        IconButton(
                          icon: const Icon(Icons.file_open_rounded),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReportScreenRejectClient()),
                            );
                          },
                          iconSize: 50,
                          color: const Color.fromARGB(255, 3, 65, 116),
                        ),
                        const Text(
                          'Rechazos de',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Cliente',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            
            Positioned(
              top: 700,
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
                    children: [Column(children: [
                        IconButton(
                          icon: const Icon(Icons.timelapse),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReportScreen()),
                            );
                          },
                          iconSize: 50,
                          color: const Color.fromARGB(255, 3, 65, 116),
                        ),
                        const Text(
                          'Duracion de Reservas',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            



            ],
        ),
      ),
    );
  }
}
