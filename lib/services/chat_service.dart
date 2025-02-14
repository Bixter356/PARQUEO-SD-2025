import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking_project/models/to_use/message.dart';

class ChatService{
  //get instance off firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



Stream<List<Map<String,dynamic>>> getOwners() {
  return FirebaseFirestore.instance
      .collection('usuario')
      .where('tipo', isEqualTo: "Dueño")
      .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        user['uid'] = doc.id;
        return user;
      }).toList();
    });
}


Stream<List<Map<String, dynamic>>> getReservationsAndOwners() {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection('reserva')
      .where('idCliente', isEqualTo: currentUserUid)
      .where('estado', isEqualTo: 'pendiente')
      .snapshots()
      .asyncMap((reservationSnapshot) async {
        Set<String> ownerIds = <String>{}; // Conjunto para almacenar los IDs de los dueños
        List<Map<String, dynamic>> ownersData = [];

        for (var reservationDoc in reservationSnapshot.docs) {
          String ownerId = reservationDoc.data()['parqueo']['idDuenio'];
          ownerIds.add(ownerId); // Añadir el ID del dueño al conjunto
        }

        for (String ownerId in ownerIds) {
          DocumentSnapshot ownerDoc = await FirebaseFirestore.instance
              .collection('usuario')
              .doc(ownerId)
              .get();
          if (ownerDoc.exists) {
            Map<String, dynamic> ownerData = ownerDoc.data() as Map<String, dynamic>;
            ownerData['uid'] = ownerDoc.id;
            ownersData.add(ownerData);
          }
        }
        return ownersData;
      });
}

Stream<List<Map<String, dynamic>>> getReservationsAndClients() {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection('reserva')
      .where('parqueo.idDuenio', isEqualTo: currentUserUid)
      .where('estado', isEqualTo: 'pendiente')
      .snapshots()
      .asyncMap((reservationSnapshot) async {
        Set<String> ownerIds = <String>{}; // Conjunto para almacenar los IDs de los dueños
        List<Map<String, dynamic>> ownersData = [];

        for (var reservationDoc in reservationSnapshot.docs) {
          String ownerId = reservationDoc.data()['idCliente'];
          ownerIds.add(ownerId); // Añadir el ID del dueño al conjunto
        }

        for (String ownerId in ownerIds) {
          DocumentSnapshot ownerDoc = await FirebaseFirestore.instance
              .collection('usuario')
              .doc(ownerId)
              .get();
          if (ownerDoc.exists) {
            Map<String, dynamic> ownerData = ownerDoc.data() as Map<String, dynamic>;
            ownerData['uid'] = ownerDoc.id;
            ownersData.add(ownerData);
          }
        }
        return ownersData;
      });
}



Stream<List<Map<String,dynamic>>> getClients() {
  return FirebaseFirestore.instance
      .collection('usuario')
      .where('tipo', isEqualTo: "Cliente")
      .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
         user['uid'] = doc.id;
        return user;
      }).toList();
    });

}


  //get user stream
  Stream<List<Map<String,dynamic>>> getUsersStream(){

    return _firestore.collection("usuario").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }




  //send message
  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //Create a new message
    Message newMessage = Message(
      senderID: currentUserID, 
      senderEmail: currentUserEmail, 
      receiverID: receiverID, 
      message: message, 
      timestamp: timestamp
    );


    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    List<String> ids =[userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("messages")
    .orderBy("timestamp", descending: false)
    .snapshots();
  }

}