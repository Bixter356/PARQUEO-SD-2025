import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/firebase_options.dart';
import 'package:parking_project/models/coleccion/vehiclecollection.dart';
import 'package:parking_project/models/to_use/usuatio_rating.dart';
import 'package:parking_project/models/to_use/vehicle.dart';

Future<UserCredential?> auntenticator(var user, var password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: user, password: password);
    return credential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
    } else if (e.code == 'wrong-password') {}
    return null; // Devuelve null en caso de error.
  }
}

Stream<QuerySnapshot> getParkingsByOwner(String ownerId) {
  return FirebaseFirestore.instance
      .collection('parqueo')
      .where('idDuenio', isEqualTo: ownerId)
      .snapshots();
}


Stream<QuerySnapshot> getAllParkings() {
  return FirebaseFirestore.instance.collection('parqueo').snapshots();
}



//-------------------------------------------------------------------------------------------


FirebaseFirestore db =FirebaseFirestore.instance;

Stream<QuerySnapshot> getVehicleData() {
  String idUser = FirebaseAuth.instance.currentUser?.uid ?? ""; // Obtener el ID del usuario autenticado
  print('UID del usuario autenticado: $idUser');

  CollectionReference collectionReference = db.collection('vehiculo');

  // Realizar la consulta filtrando por el campo 'IdCliente'
  Stream<QuerySnapshot> snapshots = collectionReference.where('idDuenio', isEqualTo: idUser).snapshots();

  // Agrega un listener para imprimir los resultados del QuerySnapshot
  snapshots.listen((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((DocumentSnapshot doc) {
      print('ID del documento: ${doc.id}');
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Agrega el ID del documento a los datos recuperados
      data['id'] = doc.id;
      print('Datos del documento: $data');
    });
  });
  return snapshots;
}









Future<void> registerVehicle(VehicleData vehicleData, BuildContext context) async {
  String idUser = "";
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {   
     idUser = user.uid;   
    print('UID del usuario autenticado: $idUser'); 
    } else {   
      print('No hay usuario autenticado'); }
  

  try {
      await FirebaseFirestore.instance
          .collection('vehiculo')
          .doc()
          .set({ 
        VehicleCollection.idCliente: idUser, 
        VehicleCollection.color: vehicleData.color,
        VehicleCollection.marca: vehicleData.marca,
        VehicleCollection.placa:vehicleData.placa,
        VehicleCollection.tipo:vehicleData.tipo,

         VehicleCollection.alto:vehicleData.alto,
         VehicleCollection.ancho:vehicleData.ancho,
         VehicleCollection.largo:vehicleData.largo,
        
        // Agrega otros campos de datos aquí
      });

  } catch (error) {
      print(error);
  }

}



//falta llenar el ccombobox
Future<VehicleData?> getVehicleDataById(String vehicleId) async {
  try {
    DocumentSnapshot vehicleSnapshot = await FirebaseFirestore.instance
        .collection('vehiculo')
        .doc(vehicleId)
        .get();

    if (vehicleSnapshot.exists) {
      Map<String, dynamic> vehicleData =
          vehicleSnapshot.data() as Map<String, dynamic>;
         String documentId = vehicleSnapshot.id;//para poder recuperar el ID
      return VehicleData(
        color: vehicleData[VehicleCollection.color],
        marca: vehicleData[VehicleCollection.marca],
        placa: vehicleData[VehicleCollection.placa],
        tipo: vehicleData[VehicleCollection.tipo],



        alto: (vehicleData[VehicleCollection.alto] as num).toDouble(),
        ancho: (vehicleData[VehicleCollection.ancho] as num).toDouble(),
        largo: (vehicleData[VehicleCollection.largo] as num).toDouble(),
        

        idCliente: vehicleData[VehicleCollection.idCliente],
        //Id para el documneto
        id: documentId,
      );
    } else {
      return null;
    }
  } catch (error) {
    
    print(error);
    return null;
  }
}



//  Completo
Future<void> updateVehicle(VehicleData vehicleData, String uid) async{
  await db.collection("vehiculo")
          .doc(uid)
          .set({
            VehicleCollection.color: vehicleData.color,
            VehicleCollection.marca: vehicleData.marca,
            VehicleCollection.placa:vehicleData.placa,
            VehicleCollection.tipo:vehicleData.tipo,

            VehicleCollection.alto:vehicleData.alto,
            VehicleCollection.ancho:vehicleData.ancho,
            VehicleCollection.largo:vehicleData.largo,

            VehicleCollection.idCliente: vehicleData.idCliente,
          });
}


Future<void> deleteVehicle(String vehicleId) async {
  try {
    await db.collection('vehiculo').doc(vehicleId).delete();
    print('Vehículo eliminado correctamente');
  } catch (e) {
    print('Error al eliminar el vehículo: $e');
  }
}



//-------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------
Future<List<VehicleData>> getFilteredVehicles(String vehicleType) async {
List<VehicleData> vehicles = [];

  try {

    String idUser = "";
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) 
  {   
     idUser = user.uid;   
    print('UID del usuario autenticado: $idUser'); 
  } else {   
      print('No hay usuario autenticado'); 
  }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('vehiculo')
        .where('idDuenio', isEqualTo: idUser)
        .where('tipo', isEqualTo: vehicleType)
        .get();

    if (querySnapshot.docs.isNotEmpty) {

      querySnapshot.docs.forEach((DocumentSnapshot doc) {

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        vehicles.add(VehicleData(
        color: data[VehicleCollection.color],
        marca: data[VehicleCollection.marca],
        placa: data[VehicleCollection.placa],
        tipo: data[VehicleCollection.tipo],
        alto: (data[VehicleCollection.alto] as num).toDouble(),
        ancho: (data[VehicleCollection.ancho] as num).toDouble(),
        largo: (data[VehicleCollection.largo] as num).toDouble(),
        idCliente: data[VehicleCollection.idCliente],
        //Id para el documneto
        id: doc.id,
        ));
      });
    }
  } catch (error) {
    print('Error al obtener los vehículos: $error');
  }
  return vehicles;
}







/////////////   CALIFICACIOONNNNNNNNNNNNNNNNNNNN
///
///
///

Future<List> getPeople() async {
  List people = [];
  CollectionReference collectionReference = db.collection('usuario');

  QuerySnapshot quertPeople = await collectionReference.get();

  for (var element in quertPeople.docs) {
    var data = element.data();
    if ((data as Map<String, dynamic>)['estado'] == 'habilitado' && (data)['tipo'] != 'Admin'){
      people.add(data);
    }
  }


  return people;
}



Future<Usuario> obtenerUsuario(String id) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Obtener el documento con el ID especificado
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("usuario").doc(id).get();
    // Veriicar si el documento existe
    if (documentSnapshot.exists) {
      // Obtener todos los datos del documento
      Map<String, dynamic>? userData =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        // Crear un objeto Usuario con los datos recuperados
        Usuario usuario = Usuario(
          id: documentSnapshot.id,
          apellido: userData['apellido'] ?? '',
          cantidadResenias: userData['cantidadResenias'] ?? 0,
          correo: userData['correo'] ?? '',
          estado: userData['estado'] ?? '',
          nombre: userData['nombre'] ?? '',
          puntaje: userData['puntaje'] ?? 0,
          sumaPuntos: userData['sumaPuntos'] ?? 0,
          telefono: userData['telefono'] ?? 0,
          tipo: userData['tipo'] ?? '',
        );
        print(usuario.puntaje);
        return usuario;
      } else {
        throw Exception('Los datos del usuario son nulos.');
      }
    } else {
      throw Exception('No se encontró ningún registro con el ID especificado.');
    }
  } catch (error) {
    if (error is FirebaseException) {
      print('Error de Firebase al obtener el usuario: $error');
    } else {
      print('Error desconocido al obtener el usuario: $error');
    }
    throw Exception('Error al obtener el usuario: $error');
  }
}

Future<void> updateItem(int puntaje, String idUsuario) async {
  try {
    // Obtener los datos del usuario
    //Usuario usuarioExistente = await obtenerUsuario('1');

    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );


    // Actualizar el puntaje del usuario
    Usuario usuario = await obtenerUsuario(idUsuario);
    usuario.sumaPuntos += puntaje;
    usuario.cantidadResenias++;
    usuario.puntaje =
        usuario.sumaPuntos ~/ usuario.cantidadResenias;



    // Realizar la actualización con el objeto modificado
    await db.collection("usuario").doc(usuario.id).set({
      'apellido': usuario.apellido,
      'cantidadResenias': usuario.cantidadResenias,
      'correo': usuario.correo,
      'nombre': usuario.nombre,
      'puntaje': usuario.puntaje,
      'sumaPuntos': usuario.sumaPuntos,
      'telefono': usuario.telefono,
      'tipo': usuario.tipo,
      'estado': 'habilitado', //OJO CON ESTO NO ESTA BIEN
    });

    
    print('Puntaje actualizado correctamente.');
  } catch (error) {
    print('Error al actualizar el puntaje: $error');
  }
}

