// import 'package:bluehpark/models/inkwell/inkwell_data.dart';
// import 'package:flutter/material.dart';

// class InkwellPerzonalized extends StatefulWidget {
//   final InkwellData inkwellData;

//   const InkwellPerzonalized({super.key, required this.inkwellData});

//   @override
//   State<InkwellPerzonalized> createState() => _InkwellPerzonalizedState();
// }

// class _InkwellPerzonalizedState extends State<InkwellPerzonalized> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           widget.inkwellData.isChecked = !widget.inkwellData.isChecked;
//         });
//       },
//       child: Container(
//         width: 100.0,
//         height: 50.0,
//         decoration: BoxDecoration(
//           color: widget.inkwellData.isChecked
//               ? const Color.fromARGB(100, 100, 218, 248)
//               : const Color.fromARGB(136, 225, 254, 252), // Color de fondo
//           borderRadius: BorderRadius.circular(10.0), // Radio de borde
//           border: Border.all(
//             color: Colors.lightBlue, // Color del borde
//             width: 2.0, // Ancho del borde
//           ),
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 15.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.inkwellData.message,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     Text(
//                       widget.inkwellData.priceString,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Mostrar el icono si isChecked es verdadero
//               if (widget.inkwellData.isChecked)
//                 const Padding(
//                   padding:
//                       EdgeInsets.only(right: 10.0), // Ajusta el espacio aquí
//                   child: Icon(
//                     Icons.check,
//                     color: Colors.green,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
