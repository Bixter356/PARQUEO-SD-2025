import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/components/user_tile.dart';
import 'package:parking_project/services/chat_service.dart';
import 'chat_client.dart';



class HomeChatClientScreen extends StatefulWidget {
  const HomeChatClientScreen({super.key});

  @override
  State<HomeChatClientScreen> createState() => _HomeChatClientScreenState();
}


class _HomeChatClientScreenState extends State<HomeChatClientScreen> {

  
  final ChatService _chatService = ChatService();
  //final AuthService _authService = AuthService();

    @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,

          appBar: AppBar(
            title: const Text("Chats"),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey,
            elevation: 0,
          ),


         // drawer: const MyDrawer(),

          body: _buildUserList(),
        );
      }


//--------------------------------------------------------------------------------


     Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getReservationsAndOwners(), 
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
    Map<String, dynamic> userData, BuildContext context) {
    //Muestra todos los usuarios, menos el actual
    if(userData["correo"] != FirebaseAuth.instance.currentUser?.email){ ///

     //userData['uid'] = FirebaseAuth.instance.currentUser?.uid;
     return UserTile(


        text: userData["correo"] + "\n " + userData['nombre'] +" "+userData['apellido'], 


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










