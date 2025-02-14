import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart'show FirebaseAuth, UserCredential;
import 'package:flutter/material.dart';
import 'package:parking_project/helpers/extensions.dart';
import 'package:parking_project/models/coleccion/collection_field.dart';
import 'package:parking_project/models/coleccion/collections.dart';
import 'package:parking_project/models/user.dart';
import 'package:parking_project/routes/routes.dart';
import 'package:parking_project/utilities/toast.dart';

class TypeUserRequest extends StatelessWidget {
  const TypeUserRequest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tipo de Cuenta',
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          iconSize: 30,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 100), // Espacio de 20 puntos en la parte superior
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamedAndRemoveUntil(
                      Routes.requestForm,
                      predicate: (route) => false,
                      arguments: ['Cliente'],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.all(16), // Ajusta el tamaño del botón
                    backgroundColor: Colors.blue, // Color de fondo del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Borde redondeado
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Cliente',
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Usuario común - Realiza    ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'reserva de parqueos',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 100), // Espacio de 20 puntos en la parte superior
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                        if (!context.mounted) return;
                        context.pushNamedAndRemoveUntil(
                          Routes.requestForm,
                          predicate: (route) => false,
                          arguments: ['Dueño'],
                        );
                    } catch (e) {
                      rethrow;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.all(16), // Ajusta el tamaño del botón
                    backgroundColor: Colors.blue, // Color de fondo del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Borde redondeado
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Dueño',
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Usuario Gestor - Realiza la',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'gestion de su parqueo',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
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
        UsersCollection.estado: 'habilitado'
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
      AccountRequestCollection.detalle: 'Esto es detalle'
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
