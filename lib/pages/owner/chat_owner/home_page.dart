// import 'package:chat_message/components/my_drawer.dart';
// import 'package:chat_message/services/auth/auth_service.dart';
// import 'package:chat_message/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/components/user_tile.dart';
import 'package:parking_project/services/chat_service.dart';
import 'chat_page.dart';



class HomeChatOwnerScreen extends StatefulWidget {
  const HomeChatOwnerScreen({super.key});

  @override
  State<HomeChatOwnerScreen> createState() => _HomeChatOwnerScreenState();
}


class _HomeChatOwnerScreenState extends State<HomeChatOwnerScreen> {

  
  final ChatService _chatService = ChatService();
  //final AuthService _authService = AuthService();

    @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,

          appBar: AppBar(
            title: const Text("Chats"),
            backgroundColor: const Color.fromARGB(0, 7, 37, 209),
            foregroundColor: Color.fromARGB(255, 59, 59, 59),
            elevation: 0,
          ),


         // drawer: const MyDrawer(),

          body: _buildUserList(),
        );
      }


//--------------------------------------------------------------------------------


     Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getReservationsAndClients(), 
      builder: (context, snapshot){
        //error
        if(snapshot.hasError){
          return const Text("Error");
        }

        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Cargando..");
        }
        
        //return list view
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context))
          .toList(),
        );
      },
    );
    }





//--------------------------------------------------------
Widget  _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context){
    //Muestra todos los usuarios, menos el actual
    if(userData["correo"] != FirebaseAuth.instance.currentUser?.email){ ///
     //userData['uid'] = FirebaseAuth.instance.currentUser?.uid;
     return UserTile(
        text: userData["correo"] + "\n" + userData['nombre'] +" "+userData['apellido'],
        onTap: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["correo"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    }else{
      return Container();
    }
  }
}










