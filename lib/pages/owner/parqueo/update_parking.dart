import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../../utilities/toast.dart';
import '../../../utilities/progressbar.dart';

class UpdateParking extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const UpdateParking({Key? key});

  @override
  _UpdateParkingState createState() => _UpdateParkingState();
}

class _UpdateParkingState extends State<UpdateParking> {
  List<bool> checkboxValues = [false, false, false];

  TextEditingController motosDiasController = TextEditingController();
  TextEditingController motosHoraController = TextEditingController();
  TextEditingController autosDiasController = TextEditingController();
  TextEditingController autosHoraController = TextEditingController();
  TextEditingController otrosDiasController = TextEditingController();
  TextEditingController otrosHoraController = TextEditingController();
  TextEditingController nombreParqueoController = TextEditingController();
  TextEditingController coberturaController = TextEditingController();
  TextEditingController horaEntradaController = TextEditingController();
  TextEditingController horaSalidaController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Llamar a una función para cargar los datos desde Firestore al inicializar el widget
    loadParqueoData();
  }

  Future<void> loadParqueoData() async {
    try {
      // Realizar una consulta para obtener un documento específico en Firestore

      DocumentSnapshot parqueoDocument = await FirebaseFirestore.instance
          .collection('parqueo')
          .doc(
              'LX4qJk0irt98bWgXLOuW') // Reemplaza 'ID_DEL_DOCUMENTO' por el ID real del documento que deseas recuperar
          .get();

      // Acceder a los datos del documento y actualizar los controladores de los campos de entrada
      Map<String, dynamic> data =
          parqueoDocument.data() as Map<String, dynamic>;
      setState(() {
        nombreParqueoController.text = 'Parqueo ${data['nombre']}';
        if (data['cobertura'] == true) {
          coberturaController.text = 'Disponible';
        } else {
          coberturaController.text = 'No Disponible';
        }
        checkboxValues[0] = data['Vehiculos Permitidos']['Motos'] ?? false;
        checkboxValues[1] =
            data['Vehiculos Permitidos']['Automoviles'] ?? false;
        checkboxValues[2] = data['Vehiculos Permitidos']['Otros'] ?? false;

        motosHoraController.text = data['tarifa_moto']['hora'].toString();
        motosDiasController.text = data['tarifa_moto']['dia'].toString();
        autosHoraController.text =data['tarifa_automoviles']['hora'].toString();
        autosDiasController.text = data['tarifa_automoviles']['dia'].toString();
        otrosHoraController.text = data['tarifa_otros']['hora'].toString();
        otrosDiasController.text = data['tarifa_otros']['dia'].toString();
        horaEntradaController.text = data['Hora apertura'];
        horaSalidaController.text = data['Hora cierre'];
      });
      // Cierra el diálogo de progreso
    } catch (e) {
      // Asegura que el diálogo se cierre en caso de error
      // ignore: use_build_context_synchronously
      Toast.show(context, 'Error al cargar los datos: $e');
    }
  }

  Future<void> actualizarDocumento() async {
    try {
      // Obtén la referencia al documento que deseas actualizar
      DocumentReference reference = FirebaseFirestore.instance .collection('parqueo').doc('LX4qJk0irt98bWgXLOuW');

      Map<String, bool> vehiculosPermitidos = <String, bool>{
        'Motos': checkboxValues[0],
        'Automoviles': checkboxValues[1],
        'Otros': checkboxValues[2],
      };
      Map<String, double> tarifaAutomoviles = {
        'hora': double.parse(autosHoraController.text),
        'dia': double.parse(autosDiasController.text)
      };
      Map<String, double> tarifaMotos = {
        'hora': double.parse(motosHoraController.text),
        'dia': double.parse(motosDiasController.text)
      };
      Map<String, double> tarifaOtros = {
        'hora': double.parse(otrosHoraController.text),
        'dia': double.parse(otrosDiasController.text)
      };
      // Crea un mapa con los datos actualizados
      Map<String, dynamic> datosActualizados = {
        'Hora apertura': horaEntradaController.text,
        'Hora cierre': horaSalidaController.text,
        'Vehiculos Permitidos': vehiculosPermitidos,
        'cobertura': coberturaController.text == 'Disponible' ? true : false,
        'nombre': nombreParqueoController.text,
        'tarifa_automoviles': tarifaAutomoviles,
        'tarifa_moto': tarifaMotos,
        'tarifa_otros': tarifaOtros
        // Agrega otros campos que desees actualizar
      };

      // Actualiza el documento en Firestore
      await reference.update(datosActualizados);

      print('Documento actualizado correctamente.');
    } catch (e) {
      print('Error al actualizar el documento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Edicion de Parqueos',
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          iconSize: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/img_parqueo.jpg',
                    width: 215,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: nombreParqueoController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets
                              .zero, // Elimina el relleno interior del TextField
                          border: InputBorder
                              .none, // Elimina el borde predeterminado
                          focusedBorder:
                              InputBorder.none, // Elimina el borde de enfoque
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        child: TextField(
                          controller: coberturaController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Cobertura',
                            hintText: 'Cobertura',
                            labelStyle: const TextStyle(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xFFE8ECF4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color(0xFFE8ECF4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 10),
                              child: Text('Vehiculos Disponibles',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Checkbox(
                                  value: checkboxValues[0],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkboxValues[0] = value ?? false;
                                    });
                                  },
                                ),
                                const Text('Motos'),
                                const SizedBox(width: 18),
                                Checkbox(
                                  value: checkboxValues[1],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkboxValues[1] = value ?? false;
                                    });
                                  },
                                ),
                                const Text('Automoviles'),
                                const SizedBox(width: 18),
                                Checkbox(
                                  value: checkboxValues[2],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkboxValues[2] = value ?? false;
                                    });
                                  },
                                ),
                                const Text('Otros'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color(0xFFE8ECF4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 10),
                              child:
                                  Text('Motos', style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Tarifa Horas:',
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                controller: motosHoraController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      5)
                                                ],
                                                textAlign: TextAlign.center,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Precio Horas',
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15.0),
                                              child: Text('Bs'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Tarifa Dias:',
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                controller: motosDiasController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      5)
                                                ],
                                                textAlign: TextAlign.center,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Tarifa Dias',
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20.0),
                                              child: Text('Bs'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10), //Aca es
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 10),
                              child: Text('Automoviles',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Tarifa Horas:',
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                controller: autosHoraController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      5)
                                                ],
                                                textAlign: TextAlign.center,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Precio Horas',
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15.0),
                                              child: Text('Bs'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Tarifa Dias:',
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                controller: autosDiasController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      5)
                                                ],
                                                textAlign: TextAlign.center,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Tarifa Dias',
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20.0),
                                              child: Text('Bs'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 10),
                              child:
                                  Text('Otros', style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Tarifa Horas:',
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                controller: otrosHoraController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      5)
                                                ],
                                                textAlign: TextAlign.center,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Precio Horas',
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15.0),
                                              child: Text('Bs'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Tarifa Dias:',
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextField(
                                                controller: otrosDiasController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      5)
                                                ],
                                                textAlign: TextAlign.center,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Tarifa Dias',
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20.0),
                                              child: Text('Bs'),
                                            ),
                                          ],
                                        ),
                                      ],
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color(0xFFE8ECF4),
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 10),
                              child: Text(
                                'Horarios',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Hora de entrada:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Hora de salida:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: TextField(
                                      controller: horaEntradaController,
                                      decoration: InputDecoration(
                                        hintText: 'Hora de entrada',
                                        labelText: 'Hora de entrada',
                                        labelStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(5.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: TextField(
                                      controller: horaSalidaController,
                                      decoration: InputDecoration(
                                        hintText: 'Hora de salida',
                                        labelText: 'Hora de salida',
                                        labelStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(5.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Alinea los botones a los extremos
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Ajusta el radio para hacerlo semi redondeado
                              ), // Cambia el color de fondo del botón
                            ),
                            onPressed: () {
                              // Acción para el botón "Regresar"
                              Navigator.pop(context);
                            },
                            child: const Text('Regresar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Ajusta el radio para hacerlo semi redondeado
                              ), // Cambia el color de fondo del botón
                            ),
                            onPressed: () async{
                              // Acción para el botón "Confirmar"
                              // Puedes agregar aquí la lógica para confirmar los horarios
                              await ProgressDialog.show(context,
                                  'Actualizando parqueo...'); // Muestra el diálogo de progreso
                              await actualizarDocumento();

                              // ignore: use_build_context_synchronously
                              await ProgressDialog.hide(context);
                              // ignore: use_build_context_synchronously
                              Toast.show(context, 'Registro Actualizado');
                            },
                            child: const Text('Confirmar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
