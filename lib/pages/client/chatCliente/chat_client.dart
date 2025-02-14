import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/components/chat_bubble.dart';
import 'package:parking_project/components/my_textfield1.dart';
import 'package:parking_project/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  
    const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    });

  @override
  State<ChatPage> createState() => _ChatPageClientState();
}

class _ChatPageClientState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  //final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        Future.delayed(
          const Duration(milliseconds: 500), 
          () => scrollDown()
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500), 
      () => scrollDown(),
    
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //Controlador para el desplazamiento
  final ScrollController _scrollController = ScrollController();

  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1), 
      curve: Curves.fastOutSlowIn,

    );
  }

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //mostrar todos los mensajes
          Expanded(child: _buildMessageList(),
          ),

          _buildUserInput(),
        ],
      ),
    );
  }


  //Metodo mostrar todos los mensajes
  Widget _buildMessageList(){
    //verificar
    String senderID = FirebaseAuth.instance.currentUser!.uid; //ojo

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID), 
      builder: (context, snapshot){
        //errors
        if(snapshot.hasError){
          return const Text("Error");
        }

        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Cargando..");
        }
        
        //return list view
        return ListView(
          controller: _scrollController,
          children: 
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc))
          .toList(),
        );
      },
    );
  }




  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == FirebaseAuth.instance.currentUser!.uid; //ojo

    var aligment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: aligment,
      child: Column(
        crossAxisAlignment: 
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"], 
            isCurrentUser: isCurrentUser,
            ),
        ],
      ),
    );
  }







  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield1(
              controller: _messageController,
              hintText: "Escriba un mensaje",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
      
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 42, 163, 200),
              shape: BoxShape.circle,

            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(
                Icons.arrow_upward, 
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}