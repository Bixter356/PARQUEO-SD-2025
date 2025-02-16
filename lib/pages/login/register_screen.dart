import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_3_27_4/helpers/extensions.dart';
import 'package:app_3_27_4/models/coleccion/collection_field.dart';
import 'package:app_3_27_4/models/coleccion/collections.dart';
import 'package:app_3_27_4/models/user.dart';
import 'package:app_3_27_4/routes/routes.dart';
import 'package:app_3_27_4/utilities/progressbar.dart';
import 'package:app_3_27_4/utilities/toast.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/Register-screen';
  final String userType;
  const RegisterScreen({super.key, required this.userType});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  int selectedGender = 0; // 0 para Hombre, 1 para Mujer
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoElectronicoController =
      TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController contrasenaConfirmarController =
      TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final double width = MediaQuery.of(context).size.width;
    //final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 33, 84),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // boton de regreso
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
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
                          'Registro de Usuario',
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
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          hintText: 'correo@gmail.com',
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
                      // Usamos un Row para colocar los RadioButtons en fila
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.userType == 'Cliente') {
                          } else if (widget.userType == 'Dueño') {}
                          UserData userData = sendUserData(widget.userType);
                          // Acción cuando se presiona el botón
                          try {
                            ProgressDialog.show(
                                context, 'Registrando usuario...');
                            await registerUser(userData, context);

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
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.0), // Ajusta el radio para hacerlo semi redondeado
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16), // Ajusta el tamaño del botón
                          backgroundColor: const Color.fromARGB(
                              255, 25, 47, 65), // Color de fondo del botón
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
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userData
          .correoElectronico, // Reemplaza con el valor del correo electrónico del usuario
      password: userData.contrasena, // Reemplaza con la contraseña del usuario
    );

    // Verifica si la creación de usuario fue exitosa

    if (userCredential.user != null) {
      String userId = userCredential.user!.uid; // Obtiene el ID del usuario

      // Ahora puedes agregar datos adicionales a la colección en Firestore
      await FirebaseFirestore.instance
          .collection(Collection.usuarios)
          .doc(userId)
          .set({
        UsersCollection.nombre: userData.nombre,
        UsersCollection.apellido: userData.apellidos,
        UsersCollection.telefono: userData.telefono,
        UsersCollection.correo: userData.correoElectronico,
        UsersCollection.tipo: userData.typeUser,
        UsersCollection.estado: 'habilitado',
        UsersCollection.puntaje: 5,
        UsersCollection.sumaPuntos: 5,
        UsersCollection.cantidadResenias: 1,
        // Agrega otros campos de datos aquí
      });
      // Registro exitoso, puedes mostrar un mensaje o redirigir al usuario a otra pantalla.
    } else {
      // Handle error: usuario no creado correctamente
      // ignore: use_build_context_synchronously
      Toast.show(context, 'Usuario no creado correctamente');
    }
  } catch (error) {
    // Handle any registration errors here
    // ignore: use_build_context_synchronously
    Toast.show(context, '$error'.toString());
  }
}

Future<void> ownerRequestAccount(
    UserData userData, BuildContext context) async {
  try {
    // Ahora puedes agregar datos adicionales a la colección en Firestore
    await FirebaseFirestore.instance
        .collection(Collection.ownerAccount)
        .doc()
        .set({
      AccountRequestCollection.nombre: userData.nombre,
      AccountRequestCollection.apellido: userData.apellidos,
      AccountRequestCollection.telefono: userData.telefono,
      AccountRequestCollection.correo: userData.correoElectronico,
      AccountRequestCollection.tipo: userData.typeUser,
      AccountRequestCollection.estado: 'pendiente',
      // Agrega otros campos de datos aquí
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
