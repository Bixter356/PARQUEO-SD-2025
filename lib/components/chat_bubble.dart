import 'package:flutter/material.dart';



class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,

    });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser 
            ? (isDarkMode ? const Color.fromARGB(255, 69, 169, 74) : Colors.green.shade500)
            : (isDarkMode ? const Color.fromARGB(255, 66, 66, 66) : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(
        message, 
        style: TextStyle(
            color: isCurrentUser 
              ? Colors.white 
              : (isDarkMode ? Colors.white : Colors.black)),
      
      ),
    );
  }
}