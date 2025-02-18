import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:app_3_27_4/models/coleccion/collection_field.dart';
import 'package:app_3_27_4/models/coleccion/collections.dart';
import 'package:app_3_27_4/models/to_use/parking.dart';
import 'package:app_3_27_4/pages/client/navigation_bar.dart';

class ReservaRegisterScreen extends StatefulWidget {
  final DataReservationSearch dataSearch;
  const ReservaRegisterScreen({super.key, required this.dataSearch});

  @override
  ReservaRegisterScreenState createState() => ReservaRegisterScreenState();
}

class ReservaRegisterScreenState extends State<ReservaRegisterScreen> {
  TextEditingController nombreParqueo = TextEditingController();
  TextEditingController pisoController = TextEditingController();
  TextEditingController filaController = TextEditingController();
  TextEditingController plazaController = TextEditingController();
  TextEditingController placaController = TextEditingController();
  TextEditingController marcaController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController modeloController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaFinController = TextEditingController();

  TextEditingController totalController = TextEditingController();

  DateTime? reservationDateIn, reservationDateOut;
  bool radioValue = false;
  List<bool> checkboxValues = [false, false, false];
  String typeVehicle = "";
  String urlImage = "";

  @override
  void initState() {
    super.initState();
    getDataReservation();
  }

  Future<void> _selectDateAndTimeInitial(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: reservationDateIn ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }

  Future<void> getDataReservation() async {
    try {
      /*DocumentSnapshot<Map<String, dynamic>> parqueoDoc =
          await widget.dataSearch.idParqueo.get()
              as DocumentSnapshot<Map<String, dynamic>>;*/
      DocumentSnapshot vehiculoDoc = await FirebaseFirestore.instance
          .collection(Collection.vehiculo)
          .doc(widget.dataSearch.idVehiculo)
          .get();
      Map<String, dynamic> dataVehicle =
          vehiculoDoc.data() as Map<String, dynamic>;

      DocumentSnapshot plazaDoc = await widget.dataSearch.idPlaza!.get();

      Map<String, dynamic> dataPlace = plazaDoc.data() as Map<String, dynamic>;

      DocumentSnapshot parkingDoc = await widget.dataSearch.idParqueo.get();

      Map<String, dynamic> dataParking =
          parkingDoc.data() as Map<String, dynamic>;

      urlImage = dataParking['url'];

      nombreParqueo.text = dataParking['nombre'];

      plazaController.text = widget.dataSearch.plaza!;
      typeVehicle = widget.dataSearch.tipoVehiculo!;
      if (widget.dataSearch.tipoVehiculo == "Moto") {
        checkboxValues[0] = true;
      } else if (widget.dataSearch.tipoVehiculo == "Automóvil") {
        checkboxValues[1] = true;
      } else if (widget.dataSearch.tipoVehiculo == "Otro") {
        checkboxValues[2] = true;
      }
      estadoController.text = dataPlace['estado'];
      //urlImage = dataParking['url'];
      urlImage =
          'https://ultrahogares.com/wp-content/uploads/2020/02/parqueo.jpg';

      //instanciamos el id del Duenio
      widget.dataSearch.idDuenio = dataParking['idDuenio'];

      placaController.text = dataVehicle['placa'];
      marcaController.text = dataVehicle['marca'];
      colorController.text = dataVehicle['color'];
      totalController.text = widget.dataSearch.total.toString();
      // modeloController.text = dataReserve['vehiculo']['modelo'];
      // radioValue = widget.dataSearch.tieneCobertura!;
      Timestamp timestampDateOut = widget.dataSearch.fechaFin!;
      reservationDateOut = timestampDateOut.toDate();
      Timestamp timestampDateIn = widget.dataSearch.fechaInicio!;
      reservationDateIn = timestampDateIn.toDate();
      // setState(() {
      fechaInicioController.text =
          DateFormat('dd/MM/yyyy HH:mm a').format(reservationDateIn!);
      fechaFinController.text =
          DateFormat('dd/MM/yyyy HH:mm a').format(reservationDateOut!);
      // });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF031b30),
      appBar: AppBar(
        backgroundColor: const Color(0xFD02334B),
        centerTitle: true,
        title: const Text(
          'Detalles Reserva',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
          iconSize: 35,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 1),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  // child: Image.network(
                  //   urlImage,
                  //   width: 215,
                  //   height: 190,
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        readOnly: true,
                        controller: nombreParqueo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(220, 217, 217, 217),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ubicacion',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text("Plaza: "),
                                        Expanded(
                                          child: TextField(
                                            readOnly: true,
                                            controller: plazaController,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Urbanist',
                                            ),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(220, 217, 217, 217),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Vehiculo',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  ignoring: true,
                                  child: Radio(
                                    value: typeVehicle,
                                    groupValue: typeVehicle,
                                    onChanged: (val) {
                                      setState(() {
                                        typeVehicle = val!;
                                      });
                                    },
                                  ),
                                ),
                                const Text('Motos'),
                                IgnorePointer(
                                  ignoring: true,
                                  child: Radio(
                                    value: typeVehicle,
                                    groupValue: typeVehicle,
                                    onChanged: (val) {
                                      setState(() {
                                        typeVehicle = val!;
                                      });
                                    },
                                  ),
                                ),
                                const Text('Automoviles'),
                                IgnorePointer(
                                  ignoring: true,
                                  child: Radio(
                                    value: typeVehicle,
                                    groupValue: typeVehicle,
                                    onChanged: (val) {
                                      setState(() {
                                        typeVehicle = val!;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'Otros',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(220, 217, 217, 217),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informacion',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Placa: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    readOnly: true,
                                    controller: placaController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Marca: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    readOnly: true,
                                    controller: marcaController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Color: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    readOnly: true,
                                    controller: colorController,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(220, 217, 217, 217),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total a pagar',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 25),
                            TextField(
                              readOnly: true,
                              controller: totalController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(220, 217, 217, 217),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Fecha Llegada',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 25),
                            TextField(
                              readOnly: true,
                              controller: fechaInicioController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(220, 217, 217, 217),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Fecha Salida',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 25),
                            TextField(
                              readOnly: true,
                              controller: fechaFinController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.only(
                                left: 80,
                                right: 80,
                                top: 20,
                                bottom: 20,
                              ),
                            ),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red[500]),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            ' Registrar',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            DocumentSnapshot<Map<String, dynamic>> userDoc =
                                await FirebaseFirestore.instance
                                    .collection(Collection.usuarios)
                                    .doc(user!.uid)
                                    .get();
                            Map<String, dynamic> userData =
                                userDoc.data() as Map<String, dynamic>;

                            Map<String, dynamic> cliente = {
                              'idCliente': user.uid,
                              'nombre': userData[UsersCollection.nombre],
                              'apellidos': userData[UsersCollection.apellido],
                              'telefono': userData[UsersCollection.telefono],
                            };
                            Map<String, dynamic> vehiculo = {
                              'tipo': typeVehicle,
                              'placaVehiculo': placaController.text,
                              'marcaVehiculo': marcaController.text,
                              'colorVehiculo': colorController.text
                            };
                            Map<String, dynamic> parqueo = {
                              'idDuenio': widget.dataSearch.idDuenio,
                              'nombre': nombreParqueo.text,
                              'plaza': plazaController.text,
                            };

                            Map<String, dynamic> data = {
                              'idParqueo': widget.dataSearch.idParqueo,
                              'idPlaza': widget.dataSearch.idPlaza,
                              'idVehiculo': widget.dataSearch.idVehiculo,
                              'idCliente': user.uid,
                              'cliente': cliente,
                              'vehiculo': vehiculo,
                              'parqueo': parqueo,
                              'estado': 'activo', //////////////////////
                              'fechaLlegada': widget.dataSearch.fechaInicio,
                              'fechaSalida': widget.dataSearch.fechaFin,
                              'fecha': DateTime.now(),
                              'total': widget.dataSearch.total,
                              'calificacionDuenio': false,
                              'calificacionCliente': false,
                            };
                            log('reserva en curso');
                            await agregarReserva(datos: data);
                            log('reserva agregada');
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MenuClient(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> agregarReserva({required Map<String, dynamic> datos}) async {
    await FirebaseFirestore.instance.collection(Collection.reservas).add(datos);
    Map<String, dynamic> data = {'estado': 'noDisponible'};
    DocumentReference plazaRef = widget.dataSearch.idPlaza!;
    await plazaRef.update(data);

    //actualizar la cantidad de cupones del usuario
    QuerySnapshot<Map<String, dynamic>> cupones = await FirebaseFirestore
        .instance
        .collection('usuario')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cupones')
        .where('idParqueo', isEqualTo: widget.dataSearch.idParqueo.id)
        .get();
    if (cupones.docs.isNotEmpty) {
      //actualizar la cantidad de cupones dado widget.dataSearch.cantidadCupones
      DocumentReference cuponRef = cupones.docs.first.reference;
      Map<String, dynamic> data = {
        'Cantidad':
            widget.dataSearch.cantidaCupones
      };
      await cuponRef.update(data);
    }
  }
}
