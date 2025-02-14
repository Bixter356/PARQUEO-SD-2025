import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_project/helpers/extensions.dart';
import 'package:parking_project/models/coleccion/collection_field.dart';
import 'package:parking_project/models/coleccion/collections.dart';
import 'package:parking_project/models/user.dart';
import 'package:parking_project/routes/routes.dart';
import 'package:parking_project/utilities/progressbar.dart';
import 'package:parking_project/utilities/toast.dart';

class RequetFormScreen extends StatefulWidget {
  static const routeName = '/Register-screen-request';
  final String userType;
  const RequetFormScreen({super.key, required this.userType});

  @override
  FormAccountScreenState createState() => FormAccountScreenState();
}

class FormAccountScreenState extends State<RequetFormScreen> {
  int selectedGender = 0; // 0 para Hombre, 1 para Mujer
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoElectronicoController =
      TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController contrasenaConfirmarController =
      TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  String uidGoogle = "";
  String correoGoogle = "";
  @override
  void initState() {
    super.initState();
    getUserData();
    // Carga los datos de la plaza en initState
  }

  Future<void> getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // El usuario ha iniciado sesión y user contiene la información del usuario.
      correoElectronicoController.text = user.email.toString();
      uidGoogle = user.uid.toString(); //Id del usuario en la coleccion 'usuarios'
      correoGoogle = user.email.toString();
      log('El usuario está autenticado: ${user.displayName}');
    } else {
      // El usuario no ha iniciado sesión.
      log('El usuario no está autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final double width = MediaQuery.of(context).size.width;
    //final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.all(20),
              child: IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 40,
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/logo_login.jpg',
                  width: 215,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Regístrese para comenzar',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Urbanist',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nombreController,
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          hintText: 'Nombre',
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: apellidosController,
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Apellidos',
                          labelText: 'Apellidos',
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: telefonoController,
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        decoration: InputDecoration(
                          hintText: 'Telefono',
                          labelText: 'Telefono',
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: correoElectronicoController,
                        readOnly: true,
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          hintText: 'correo@example.com',
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: contrasenaController,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Ingresa una Contraseña',
                          hintText: 'Contraseña',
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: contrasenaConfirmarController,
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          hintText: 'Confirmar Contraseña',
                          filled: true,
                          fillColor: const Color(0xFFE8ECF4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Género',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Usamos un Row para colocar los RadioButtons en fila
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Hombre'),
                              leading: Radio<int>(
                                value: 0,
                                groupValue: selectedGender,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedGender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Mujer'),
                              leading: Radio<int>(
                                value: 1,
                                groupValue: selectedGender,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedGender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                            UserData userData = sendUserData(widget.userType);
                            userData.id = uidGoogle;

                            if (widget.userType == 'Cliente') {
                              // Acción cuando se presiona el botón
                              try {
                                if (!context.mounted) return;
                                ProgressDialog.show(
                                    context, 'Registrando usuario...');
                                if (!context.mounted) return;
                                await registerUser(userData, context);

                                // ignore: use_build_context_synchronously
                                ProgressDialog.hide(context);
                                if (!context.mounted) return;
                                context.pushNamedAndRemoveUntil(
                                  Routes.clientMenuScreen,
                                  predicate: (route) => false,
                                );
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                Toast.show(context, e.toString());
                              }
                            } else if (widget.userType == 'Dueño') {
                              try {
                                if (!context.mounted) return;
                                ProgressDialog.show(
                                    context, 'Registrando usuario...');
                                if (!context.mounted) return;
                                await ownerRequestAccount(userData, context);

                                // ignore: use_build_context_synchronously
                                ProgressDialog.hide(context);
                                if (!context.mounted) return;
                                  context.pushNamedAndRemoveUntil(
                                    Routes.loginScreen,
                                    predicate: (route) => false,
                                  );
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                Toast.show(context, e.toString());
                              }
                            }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.0), // Ajusta el radio para hacerlo semi redondeado
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16), // Ajusta el tamaño del botón
                          backgroundColor:
                              Colors.blue, // Color de fondo del botón
                        ),
                        child: const Text(
                          'Registrarse', // Texto del botón
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Color del texto
                          ),
                        ),
                      ),
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

  UserData sendUserData(String userType) {
    UserData userData = UserData(
        nombre: nombreController.text,
        apellidos: apellidosController.text,
        telefono: int.parse(telefonoController.text),
        correoElectronico: correoElectronicoController.text,
        contrasena: contrasenaController.text,
        genero: selectedGender == 0 ? 'Masculino' : 'Femenino',
        typeUser: userType);

    return userData;
  }
}

Future<void> registerUser(UserData userData, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection(Collection.usuarios)
        .doc(userData.id)
        .set({
      UsersCollection.nombre: userData.nombre,
      UsersCollection.apellido: userData.apellidos,
      UsersCollection.correo: userData.correoElectronico,
      UsersCollection.telefono: userData.telefono,
      UsersCollection.tipo: userData.typeUser,
      UsersCollection.estado: 'habilitado',
      'cantidadResenias':1,
      'puntaje':5,
      'sumaPuntos':5
    });
  } catch (error) {
    // Handle any registration errors here
    // ignore: use_build_context_synchronously
    Toast.show(context, '$error'.toString());
  }
}

Future<void> ownerRequestAccount(
    UserData userData, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection(Collection.ownerAccount)
        .doc(userData.id)
        .set({
      AccountRequestCollection.nombre: userData.nombre,
      AccountRequestCollection.apellido: userData.apellidos,
      AccountRequestCollection.telefono: userData.telefono,
      AccountRequestCollection.correo: userData.correoElectronico,
      AccountRequestCollection.tipo: userData.typeUser,
      AccountRequestCollection.estado: 'pendiente',
      AccountRequestCollection.detalle: 'Peticion de Habilitacion de cuenta'
    });
    if (!context.mounted) return;
    Toast.show(
        context, 'Se ha realizado la Solicitud\nSe le notificara al correo');
  } catch (error) {
    // Handle any registration errors here
    // ignore: use_build_context_synchronously
    Toast.show(context, '$error'.toString());
  }
}
