import 'package:app_3_27_4/pages/owner/home_owner_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

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
        controller.pauseCamera(); // Pausa la cámara después de detectar un QR
        qrCodeValue = scanData.code ?? "Error al escanear";
        print("QR Escaneado: $qrCodeValue"); // Imprimir en consola

        _showQRDialog(qrCodeValue!);
      }
    });
  }

  void _showQRDialog(String qrData) {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita cerrar tocando fuera del dialog
      builder: (context) {
        return AlertDialog(
          title: const Text("QR escaneado correctamente"),
          content: Text("Código: $qrData"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                setState(() {
                  qrCodeValue = null; // Restablece el valor del código QR
                });
                controller?.resumeCamera(); // Reinicia la cámara para escanear de nuevo
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear QR")),
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

/// Superposición visual para el escáner
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
