import 'package:app_3_27_4/pages/owner/home_owner_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'dart:developer'; 

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCodeValue;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      if (mounted && qrCodeValue == null) {
        controller.pauseCamera(); 
        qrCodeValue = scanData.code ?? "Error al escanear";
        print("QR Escaneado: $qrCodeValue");

        _showQRDialog(qrCodeValue!);
        _updatePlazaStatus(qrCodeValue!); 
        _updateReservaFecha(qrCodeValue!); 
        _actualizarOCrearCupon(qrCodeValue!); 
      }
    });
  }

  void _showQRDialog(String qrData) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          title: const Text("QR escaneado correctamente"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                setState(() {
                  qrCodeValue = null; 
                });
                controller?.resumeCamera();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePlazaStatus(String qrData) async {
    try {
      List<String> ids = qrData.split('-');
      if (ids.length >= 4) {
        String parqueoId = ids[0];  
        String plazaId = ids[1];    

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference parqueoRef = firestore.collection('parqueo').doc(parqueoId);
        DocumentReference plazaRef = parqueoRef.collection('plazas').doc(plazaId);

        await plazaRef.update({'estado': 'noDisponible'});

        print('Estado actualizado a noDisponible para la plaza con ID: $plazaId');
      } else {
        print('QR escaneado no contiene los IDs esperados.');
      }
    } catch (e) {
      print('Error al actualizar el estado de la plaza: $e');
    }
  }

  Future<void> _updateReservaFecha(String qrData) async {
    try {
      List<String> ids = qrData.split('-');
      if (ids.length >= 3) {
        String reservaId = ids[2]; 
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference reservaRef = firestore.collection('reserva').doc(reservaId);

        await reservaRef.update({
          'fechaLlegadaReal': FieldValue.serverTimestamp(),
        });

        print('Fecha de llegada real actualizada para la reserva con ID: $reservaId');
      } else {
        print('QR escaneado no contiene el ID de reserva esperado.');
      }
    } catch (e) {
      print('Error al actualizar la fecha de llegada real: $e');
    }
  }

  Future<void> _actualizarOCrearCupon(String qrData) async {
    try {
      List<String> ids = qrData.split('-');
      if (ids.length >= 4) {
        String parqueoId = ids[0];  
        String usuarioId = ids[3];  

        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference cuponesRef =
            firestore.collection('usuario').doc(usuarioId).collection('cupones');
        
        // Consulta si existe un cupón para este usuario y parqueo
        Query query = cuponesRef.where('idParqueo', isEqualTo: parqueoId);

        QuerySnapshot querySnapshot = await query.get();

        if (querySnapshot.docs.isNotEmpty) {
          // Si el cupón ya existe, actualiza la cantidad
          for (var doc in querySnapshot.docs) {
            dynamic cant = doc.data();
            await cuponesRef.doc(doc.id).update({
              'Cantidad': (cant['Cantidad'] ?? 0) + 1,
            });
            log("Cantidad del cupón actualizada");
          }
        } else {
          // Si no existe, crea un nuevo cupón
          await cuponesRef.add({
            'idParqueo': parqueoId,
            'Cantidad': 1, // Cantidad inicial
          });
          log("Nuevo cupón creado con éxito");
        }
      } else {
        print('QR escaneado no contiene los IDs de parqueo y usuario esperados.');
      }
    } catch (e) {
      log("Error al actualizar o crear cupón: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear QR" , style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF031b30),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: QRScannerOverlayPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    double scanArea = 250;
    double left = (size.width - scanArea) / 2;
    double top = (size.height - scanArea) / 2;

    RRect scanRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, scanArea, scanArea),
      const Radius.circular(20),
    );

    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRRect(scanRect);
    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    canvas.drawRRect(scanRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
