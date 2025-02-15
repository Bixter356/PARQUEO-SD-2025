import 'dart:developer';
import 'dart:io' show File;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_picker/flutter_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:app_3_27_4/helpers/extensions.dart';
import 'package:app_3_27_4/routes/routes.dart';
import 'package:app_3_27_4/utilities/progressbar.dart';
import 'package:app_3_27_4/utilities/toast.dart';

class RegistroParqueoScreen extends StatefulWidget {
  static const routeName = '/register-parking-srceen';

  const RegistroParqueoScreen({super.key});
  @override
  RegistroParqueoScreenState createState() => RegistroParqueoScreenState();
}

class RegistroParqueoScreenState extends State<RegistroParqueoScreen> {
  String? vehiculoSeleccionado = "Autos";
  List<DateTime?> selectedDate = [null, null];
  List<TimeOfDay?> selectedTime = [null, null];
  double lati = 0, long = 0;
  TextEditingController nombreController = TextEditingController();

  TextEditingController direccionController = TextEditingController();

  TextEditingController latitudController = TextEditingController();

  TextEditingController longitudController = TextEditingController();

  bool tieneCobertura = true;

  TextEditingController descripcionController = TextEditingController();

  Map<String, bool>? vehiculosPermitidosController;

  TextEditingController nitController = TextEditingController();

  Map<String, double>? tarifaMotoController;

  Map<String, double>? tarifaAutomovilController;

  Map<String, double>? tarifaOtroController;

  TextEditingController motoHoraController = TextEditingController();
  TextEditingController motoDiaController = TextEditingController();
  TextEditingController automovilHoraController = TextEditingController();
  TextEditingController automovilDiaController = TextEditingController();
  TextEditingController otroHoraController = TextEditingController();
  TextEditingController otroDiaController = TextEditingController();

  TextEditingController motoAlturaController = TextEditingController();
  TextEditingController motoAnchoController = TextEditingController();
  TextEditingController motoLargoController = TextEditingController();

  TextEditingController autoAlturaController = TextEditingController();
  TextEditingController autoAnchoController = TextEditingController();
  TextEditingController autoLargoController = TextEditingController();

  TextEditingController otroAlturaController = TextEditingController();
  TextEditingController otroAnchoController = TextEditingController();
  TextEditingController otroLargoController = TextEditingController();

  bool autoSelected = false;
  bool motoSelected = false;
  bool mixtoSelected = false;

  bool lunesSelected = false;
  bool martesSelected = false;
  bool miercolesSelected = false;
  bool juevesSelected = false;
  bool viernesSelected = false;
  bool sabadoSelected = false;
  bool domingoSelected = false;

  File? _image;

  File? _imageInterna;

  Future<void> _getImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        log('No image selected.');
      }
    });
  }

  Future<void> _getImageFromGalleryInterna() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);


    setState(() {
      if (pickedFile != null) {
        _imageInterna = File(pickedFile.path);
      } else {
        log('No image selected.');
      }
    });


  }

  Future<void> _selectDateAndTimeFinal(BuildContext context) async {
    // ignore: use_build_context_synchronously
    final TimeOfDay? pickedTime = await showTimePicker(
        helpText: 'Seleccione la hora',
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate[0] ?? DateTime.now()));
    if (pickedTime != null) {
      setState(() {
        selectedDate[1] = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        selectedTime[1] = pickedTime;
      });
    }
  }

  Future<void> _selectDateAndTimeInitial(BuildContext context) async {
    // ignore: use_build_context_synchronously
    final TimeOfDay? pickedTime = await showTimePicker(
      helpText: 'Seleccione la hora',
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        selectedDate[0] ?? DateTime.now(),
      ),
    );
    if (pickedTime != null) {
      setState(() {
        selectedDate[0] = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        selectedTime[0] = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    //final double height = MediaQuery.of(context).size.height;
    //final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 65, 100, 140),
        title: const Text(
          "Registro de Parqueo",
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          iconSize: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Nombre del Parqueo",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: nombreController,
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Este campo no puede estar vacío';
                          }
                        },
                        maxLength: 30,

                        decoration: InputDecoration(
                          hintText: 'Ingrese el nombre del Parqueo',
                          hintStyle: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Imagen del parqueo',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                          color: const Color(0xFFE8ECF4),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            if (_image != null)
                              Center(
                                // Centra la imagen
                                child: SizedBox(
                                  width: 250,
                                  height: 200,
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (_image != null)
                              IconButton(
                                onPressed: () => {
                                  setState(() {
                                    _image = null;
                                  })
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[600],
                                ),
                              ),
                            if (_image == null)
                              InkWell(
                                onTap: () => _getImageFromGallery(),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.photo_library,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Selecciona imagen'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Imagen del parte Interna',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                          color: const Color(0xFFE8ECF4),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            if (_imageInterna != null)
                              Center(
                                // Centra la imagen
                                child: SizedBox(
                                  width: 250,
                                  height: 200,
                                  child: Image.file(
                                    _imageInterna!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (_imageInterna != null)
                              IconButton(
                                onPressed: () => {
                                  setState(() {
                                    _imageInterna = null;
                                  })
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[600],
                                ),
                              ),
                            if (_imageInterna == null)
                              InkWell(
                                onTap: () => _getImageFromGalleryInterna(),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.photo_library,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Selecciona imagen'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "Dirección del Parqueo",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo Obligatorio';
                          }
                          return null;
                        },
                        controller: direccionController,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          hintText: 'Ingrese la direccion del Parqueo',
                          hintStyle: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            "Ubicación",
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (!context.mounted) return;
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return MapLocationPicker(
                                      initialLatitude: -17.409290128439043,
                                      initialLongitude: -66.16848655550729,
                                      onPicked: (pickedData) {
                                        setState(() {
                                          /*address = pickedData.address +
                                              pickedData.latitude.toString() +
                                              pickedData.longitude.toString();*/
                                          lati = pickedData.latitude ?? 0;
                                          long = pickedData.longitude ?? 0;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const LocationPicker()), //),
                              // );
                            },
                            icon: const Icon(
                              Icons.location_on,
                              size: 30,
                            ),
                            color: Colors.blue[500],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Cuenta con cubierta",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          const Text("No"),
                          Switch(
                            value: tieneCobertura,
                            onChanged: (value) {
                              setState(() {
                                tieneCobertura = value ? true : false;
                              });
                            },
                          ),
                          const Text("Sí"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Descripción Medidas",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        maxLines: 4,
                        controller: descripcionController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ), // Ajusta estos valores según tus necesidades
                          hintText: 'Descripcion del Parqueo',
                          hintStyle: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 20),
                      const Text(
                        "Dias permitidos",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            value: lunesSelected,
                            onChanged: (value) {
                              setState(() {
                                lunesSelected = value!;
                              });
                            },
                          ),
                          const Text("Lunes"),
                          Checkbox(
                            value: martesSelected,
                            onChanged: (value) {
                              setState(() {
                                martesSelected = value!;
                              });
                            },
                          ),
                          const Text("Martes"),
                          Checkbox(
                            value: miercolesSelected,
                            onChanged: (value) {
                              setState(() {
                                miercolesSelected = value!;
                              });
                            },
                          ),
                          const Text("Miercoles"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            value: juevesSelected,
                            onChanged: (value) {
                              setState(() {
                                juevesSelected = value!;
                              });
                            },
                          ),
                          const Text("Jueves"),
                          Checkbox(
                            value: viernesSelected,
                            onChanged: (value) {
                              setState(() {
                                viernesSelected = value!;
                              });
                            },
                          ),
                          const Text("Viernes"),
                          Checkbox(
                            value: sabadoSelected,
                            onChanged: (value) {
                              setState(() {
                                sabadoSelected = value!;
                              });
                            },
                          ),
                          const Text("Sabado"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: domingoSelected,
                              onChanged: (value) {
                                setState(() {
                                  domingoSelected = value!;
                                });
                              },
                            ),
                            const Text("Domingo")
                          ]),
                      const SizedBox(height: 20),

                      const Text(
                        "Vehículos permitidos",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            value: autoSelected,
                            onChanged: (value) {
                              setState(() {
                                autoSelected = value!;
                              });
                            },
                          ),
                          const Text("Autos"),
                          Checkbox(
                            value: motoSelected,
                            onChanged: (value) {
                              setState(() {
                                motoSelected = value!;
                              });
                            },
                          ),
                          const Text("Motos"),
                          Checkbox(
                            value: mixtoSelected,
                            onChanged: (value) {
                              setState(() {
                                mixtoSelected = value!;
                              });
                            },
                          ),
                          const Text("Otros"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Tarifas",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tarifas para autos
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'Autos',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: automovilHoraController,
                              keyboardType: TextInputType.number,
                              enabled: autoSelected,
                              // Opción habilitada o deshabilitada según el valor de autoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'tarifa por hora',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: automovilDiaController,
                              keyboardType: TextInputType.number,
                              enabled: autoSelected,
                              // Opción habilitada o deshabilitada según el valor de autoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'tarifa por día',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Tarifas para motos
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'Motos',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: motoHoraController,
                              keyboardType: TextInputType.number,
                              enabled: motoSelected,
                              // Opción habilitada o deshabilitada según el valor de motoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'tarifa por hora',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: motoDiaController,
                              keyboardType: TextInputType.number,
                              enabled: motoSelected,
                              // Opción habilitada o deshabilitada según el valor de motoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'tarifa por día',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Tarifas para otros vehículos
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'Otros',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: otroHoraController,
                              keyboardType: TextInputType.number,
                              enabled: mixtoSelected,
                              // Opción habilitada o deshabilitada según el valor de mixtoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'tarifa por hora',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: otroDiaController,
                              keyboardType: TextInputType.number,
                              enabled: mixtoSelected,
                              // Opción habilitada o deshabilitada según el valor de mixtoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'tarifa por día',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(
                        "Dimensión vehículos",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tarifas para autos
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'Autos',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: autoAlturaController,
                              keyboardType: TextInputType.number,
                              enabled: autoSelected,
                              // Opción habilitada o deshabilitada según el valor de autoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'altura',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: autoAnchoController,
                              keyboardType: TextInputType.number,
                              enabled: autoSelected,
                              // Opción habilitada o deshabilitada según el valor de autoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'ancho',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: autoLargoController,
                              keyboardType: TextInputType.number,
                              enabled: autoSelected,
                              // Opción habilitada o deshabilitada según el valor de autoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'largo',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Tarifas para motos
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'Motos',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: motoAlturaController,
                              keyboardType: TextInputType.number,
                              enabled: motoSelected,
                              // Opción habilitada o deshabilitada según el valor de motoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'altura',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: motoAnchoController,
                              keyboardType: TextInputType.number,
                              enabled: motoSelected,
                              // Opción habilitada o deshabilitada según el valor de motoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'ancho',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: motoLargoController,
                              keyboardType: TextInputType.number,
                              enabled: motoSelected,
                              // Opción habilitada o deshabilitada según el valor de motoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'largo',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Tarifas para otros vehículos
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'Otros',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: otroAlturaController,
                              keyboardType: TextInputType.number,
                              enabled: mixtoSelected,
                              // Opción habilitada o deshabilitada según el valor de mixtoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'altura',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: otroAnchoController,
                              keyboardType: TextInputType.number,
                              enabled: mixtoSelected,
                              // Opción habilitada o deshabilitada según el valor de mixtoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'ancho',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: otroLargoController,
                              keyboardType: TextInputType.number,
                              enabled: mixtoSelected,
                              // Opción habilitada o deshabilitada según el valor de mixtoSelected
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'largo',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8ECF4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Text(
                        'Horario de Apertura ',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 14,
                          left: 14,
                          bottom: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                          color: const Color(0xFFE8ECF4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _selectDateAndTimeInitial(context),
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(
                                      width:
                                          8), // Espacio entre el ícono y el texto
                                  Text(
                                    selectedDate[0] != null
                                        ? DateFormat('HH:mm')
                                            .format(selectedDate[0]!)
                                        : 'Selecciona la hora',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Horario de Cierre ',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 14,
                          left: 14,
                          bottom: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black87,
                            width: 1.0,
                          ),
                          color: const Color(0xFFE8ECF4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () => {
                                if (selectedDate[0] != null)
                                  {_selectDateAndTimeFinal(context)}
                                else
                                  {
                                    Toast.show(context,
                                        'Primero seleccione la fecha de ')
                                  }
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons
                                      .calendar_today), // Ícono de calendario
                                  const SizedBox(
                                      width:
                                          8), // Espacio entre el ícono y el texto
                                  Text(
                                    selectedDate[1] != null
                                        ? DateFormat('HH:mm')
                                            .format(selectedDate[1]!)
                                        : 'Selecciona la hora',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onHover: (value) => {if (value) {}},
                          style: ButtonStyle(
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.only(
                                left: width / 8,
                                right: width / 8,
                                top: 20,
                                bottom: 20,
                              ),
                            ),
                            backgroundColor: MaterialStatePropertyAll<Color?>(
                              Colors.red[500],
                            ),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ), // Ajusta el radio para redondear las esquinas
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await ProgressDialog.show(
                              context,
                              'Registrando Parqueo',
                            );
                            String? urlPath = await addImageToFireStorage();
                            String? urlPathInterna =
                                await addImageToFireStorageInterna();
                            if (urlPath != null ||
                                urlPath != '' ||
                                urlPathInterna != null ||
                                urlPathInterna != '') {
                              GeoPoint ubicacion = GeoPoint(lati, long);
                              Map<String, bool> vhp = {
                                'Autos': autoSelected,
                                'Motos': motoSelected,
                                'Otros': mixtoSelected
                              };
                              Map<String, double> tarifaMoto = {
                                'Dia': double.parse(motoDiaController.text),
                                'Hora': double.parse(motoHoraController.text)
                              };
                              Map<String, double> tarifaAutomovil = {
                                'Dia':
                                    double.parse(automovilDiaController.text),
                                'Hora':
                                    double.parse(automovilHoraController.text)
                              };
                              Map<String, double> tarifaOtro = {
                                'Dia': double.parse(otroDiaController.text),
                                'Hora': double.parse(otroHoraController.text)
                              };
                              Map<String, double> dimensiones = {
                                'autoAltura':
                                    double.parse(autoAlturaController.text),
                                'autoAncho':
                                    double.parse(autoAnchoController.text),
                                'autoLargo':
                                    double.parse(autoLargoController.text),
                                'motoAltura':
                                    double.parse(motoAlturaController.text),
                                'motoAncho':
                                    double.parse(motoAnchoController.text),
                                'motoLargo':
                                    double.parse(motoLargoController.text),
                                'otroAltura':
                                    double.parse(otroAlturaController.text),
                                'otroAncho':
                                    double.parse(otroAnchoController.text),
                                'otroLargo':
                                    double.parse(otroLargoController.text),
                              };
                              List<dynamic> diasPermitidos = [];
                              if (lunesSelected) diasPermitidos.add('Lunes');
                              if (martesSelected) diasPermitidos.add('Martes');
                              if (miercolesSelected)
                                diasPermitidos.add('Miercoles');
                              if (juevesSelected) diasPermitidos.add('Jueves');
                              if (viernesSelected)
                                diasPermitidos.add('Viernes');
                              if (sabadoSelected) diasPermitidos.add('Sabado');
                              if (domingoSelected) {
                                diasPermitidos.add('Domingo');
                              }

                              //OJO VALIDAR---------------------------------------------
                              final User? user =
                                  FirebaseAuth.instance.currentUser;
                              Map<String, dynamic> data = {
                                'nombre': nombreController.text,
                                'direccion': direccionController.text,
                                'ubicacion': ubicacion,
                                'tieneCobertura': tieneCobertura,
                                'descripcion': descripcionController.text,
                                'vehiculosPermitidos': vhp,
                                'nit': nitController.text,
                                'tarifaMoto': tarifaMoto,
                                'tarifaAutomovil': tarifaAutomovil,
                                'tarifaOtro': tarifaOtro,
                                'horaApertura': selectedDate[0],
                                'horaCierre': selectedDate[1],
                                'url': urlPath,
                                'urlInterna': urlPathInterna,
                                'idDuenio': user!.uid,
                                'puntaje': 5,
                                'sumaPuntos': 5,
                                'cantidadResenia': 1,
                                'diasApertura': diasPermitidos,
                                'dimensiones': dimensiones,
                              };
                              await agregarParqueo(datos: data);
                              if (!context.mounted) return;
                              await ProgressDialog.hide(context);
                              if (!context.mounted) return;
                              context.pushNamedAndRemoveUntil(
                                Routes.homeScreenOwner,
                                predicate: (route) => false,
                              );
                            }
                          },
                          child: const Text(
                            'Registrar',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ], //Aca  borrar
        ),
      ),
    );
  }

  Future<void> agregarParqueo({required Map<String, dynamic> datos}) async {
    // Obtén una referencia a la colección principal, en este caso, 'parqueos'
    var parqueos = FirebaseFirestore.instance.collection('parqueo');
    try {
      String? imageUrl = await addImageToFireStorage();
      if (imageUrl!.isNotEmpty) {
        // Establece el nombre de archivo en los datos
        datos['url'] = imageUrl;

        await parqueos.add(datos);
        if (!context.mounted) return;
        Toast.show(context, 'Parqueo Registrado Correctamente');
      } else {
        // Trata el caso en el que no se pudo obtener la URL de la imagen
      }
    } catch (e) {
      if (!context.mounted) return;
      // Maneja cualquier excepción que pueda ocurrir
      Toast.show(context, 'Error: $e');
    }
  }

  Future<String?> addImageToFireStorage() async {
    try {
      String namefile = _image!.path.split('/').last;
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('parqueos').child(namefile);

      final SettableMetadata metadata =
          SettableMetadata(contentType: 'image/jpeg');

      UploadTask task = storageReference.putFile(
        _image!,
        metadata, // Establece las opciones de almacenamiento aquí
      );
      TaskSnapshot taskSnapshot = await task.whenComplete(() => true);

      if (taskSnapshot.state == TaskState.success) {
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        return '';
      }
    } catch (e) {
      Toast.show(context, e.toString());
    }
    return '';
  }

  Future<String?> addImageToFireStorageInterna() async {
    try {
      String namefile = _imageInterna!.path.split('/').last;
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('parqueos').child(namefile);

      final SettableMetadata metadata =
          SettableMetadata(contentType: 'image/jpeg');

      UploadTask task = storageReference.putFile(
        _imageInterna!,
        metadata, // Establece las opciones de almacenamiento aquí
      );
      TaskSnapshot taskSnapshot = await task.whenComplete(() => true);

      if (taskSnapshot.state == TaskState.success) {
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        return '';
      }
    } catch (e) {
      Toast.show(context, e.toString());
    }
    return '';
  }
}
