import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 3, 7, 54),
          
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            //icono
            const Icon(Icons.person, color: Colors.white),
            //nombre de usuario
            const SizedBox(width: 20),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
          
        ),
      ),
    );
  }
}