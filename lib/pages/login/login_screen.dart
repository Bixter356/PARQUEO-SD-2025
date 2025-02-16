import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_3_27_4/components/my_textfield.dart';
import 'package:app_3_27_4/helpers/extensions.dart';
import 'package:app_3_27_4/models/auth/auth_service.dart';
import 'package:app_3_27_4/models/coleccion/collection_field.dart';
import 'package:app_3_27_4/models/coleccion/collections.dart';
import 'package:app_3_27_4/pages/admin/accounts_request.dart';
import 'package:app_3_27_4/pages/admin/navigator_bar_admin.dart';
import 'package:app_3_27_4/pages/client/navigation_bar.dart';
import 'package:app_3_27_4/pages/login/type_user.dart';
import 'package:app_3_27_4/pages/owner/navigation_owner.dart';
import 'package:app_3_27_4/routes/routes.dart';
import 'package:app_3_27_4/services/temporal.dart';
import 'package:app_3_27_4/utilities/progressbar.dart';
import 'package:app_3_27_4/utilities/toast.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login-screen-page';
  LoginPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> checkSession(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final document = firestore.collection(Collection.usuarios).doc(user.uid);
      final docSnapshot = await document.get();
      // El usuario ha iniciado sesión y user contiene la información del usuario.
      final data = docSnapshot.data() as Map<String, dynamic>;
      if (data[UsersCollection.estado] == 'habilitado') {
        if (data['tipo'] == "Cliente") {
          if (!context.mounted) return;
          ProgressDialog.hide(context);
          context.pushNamedAndRemoveUntil(
            Routes.clientMenuScreen,
            predicate: (route) => false,
          );
        } else if (data['tipo'] == "Dueño") {
          if (!context.mounted) return;
          // ignore: use_build_context_synchronously
          ProgressDialog.hide(context);
          context.pushNamedAndRemoveUntil(
            Routes.ownerMenuScreen,
            predicate: (route) => false,
          );
        }
      } else {
        // El usuario no ha iniciado sesión.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                const Icon(
                  Icons.car_crash,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Bienvenido a LUH-PARKING!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Correo',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '¿ Olvidaste tu contraseña ?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                InkWell(
                  onTap: () async {
                    if (!context.mounted) return;
                    ProgressDialog.show(context, 'Iniciando Sesión...');
                    UserCredential? credential = await auntenticator(
                        emailController.text, passwordController.text);

                    if (credential != null) {
                      String id = credential.user!.uid;
                      DocumentReference userReference = FirebaseFirestore
                          .instance
                          .collection(Collection.usuarios)
                          .doc(id);
                      DocumentSnapshot<Map<String, dynamic>> user =
                          await userReference.get()
                              as DocumentSnapshot<Map<String, dynamic>>;

                      if (!context.mounted) return;
                      ProgressDialog.hide(context);
                      // Autenticación exitosa, puedes navegar a la siguiente pantalla
                      if (user['tipo'] == "Cliente") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuClient(),
                          ),
                        );
                      } else if (user['tipo'] == "Dueño") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuOwner(),
                          ),
                        );
                      } else if (user['tipo'] == "Admin") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuAdmin(),
                          ),
                        );
                      }
                    } else {
                      if (!context.mounted) return;
                      ProgressDialog.hide(context);
                      // Autenticación fallida, muestra un mensaje de error
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error de autenticación'),
                          content:
                              const Text('Usuario o contraseña incorrectos.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                    /*Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const SuccessfulScreen()));*/
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 9, 57, 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'O continuar con:',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // google sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google button
                    InkWell(
                      onTap: () async {
                        try {
                          ProgressDialog.show(context, 'Iniciando Sesión...');
                          AuthService authService = AuthService();
                          final User? user =
                              await authService.signInWithGoogle();
                          if (!context.mounted) return;

                          if (user != null) {
                            final firestore = FirebaseFirestore.instance;
                            final document = firestore
                                .collection(Collection.usuarios)
                                .doc(user.uid);
                            final docSnapshot = await document.get();
                            final document2 = firestore
                                .collection(Collection.ownerAccount)
                                .doc(user.uid);
                            final docSnapshot2 = await document2.get();
                            if (docSnapshot.exists) {
                              final data =
                                  docSnapshot.data() as Map<String, dynamic>;
                              if (data[UsersCollection.estado] ==
                                  'habilitado') {
                                if (data['tipo'] == "Cliente") {
                                  if (!context.mounted) return;
                                  ProgressDialog.hide(context);
                                  context.pushNamedAndRemoveUntil(
                                    Routes.clientMenuScreen,
                                    predicate: (route) => false,
                                  );
                                } else if (data['tipo'] == "Dueño") {
                                  if (!context.mounted) return;
                                  // ignore: use_build_context_synchronously
                                  ProgressDialog.hide(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MenuOwner(),
                                    ),
                                  );
                                } else if (data['tipo'] == "Admin") {
                                  if (!context.mounted) return;
                                  // ignore: use_build_context_synchronously
                                  ProgressDialog.hide(context);
                                  // context.pushNamedAndRemoveUntil(
                                  //   Routes.homeScreenAdmin,
                                  //   predicate: (route) => false,
                                  // );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MenuAdmin(),
                                    ),
                                  );
                                }
                              } else {
                                if (!context.mounted) return;
                                ProgressDialog.hide(context);
                                Toast.show(context, 'Cuenta Inhabilitada');
                              }
                            } else if (docSnapshot2.exists) {
                              final data =
                                  docSnapshot2.data() as Map<String, dynamic>;

                              if (data.containsKey(UsersCollection.correo)) {
                                // El campo 'correo' existe en el documento.
                                if (!context.mounted) return;
                                ProgressDialog.hide(context);
                                Toast.show(
                                    context, 'Cuenta pendiente de aprobación');
                                // Realiza las acciones que desees en este caso.
                              } else {
                                // El campo 'correo' no existe en el documento.
                                if (!context.mounted) return;
                                ProgressDialog.hide(context);
                                context.pushNamedAndRemoveUntil(
                                  Routes.requestType,
                                  predicate: (route) => false,
                                );
                                // Realiza otras acciones aquí.
                              }
                            } else {
                              if (!context.mounted) return;
                              ProgressDialog.hide(context);
                              context.pushNamedAndRemoveUntil(
                                Routes.requestType,
                                predicate: (route) => false,
                              );
                              // Realiza acciones si el documento no existe.
                            }
                          } else {
                            if (!context.mounted) return;
                            ProgressDialog.hide(context);
                            Toast.show(
                                context, 'error al iniciar sesion con google');
                          }
                        } catch (e) {
                          rethrow;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        child: Image.asset(
                          'assets/google.png',
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tiene Cuenta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TypeUser(),
                          ),
                        );
                      },
                      child: const Text(
                        'Registrarse ahora',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
