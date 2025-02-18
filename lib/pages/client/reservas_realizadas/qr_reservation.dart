import 'package:app_3_27_4/pages/client/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ReservationQRPage extends StatelessWidget {
  final String qrData;

  const ReservationQRPage({super.key, required this.qrData});

  String _generateUniqueCode() {
    return qrData;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueCode = _generateUniqueCode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF031b30),
        title: const Text(
          'Código QR de la reserva',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Escanea el código QR para ver la reserva',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  QrImageView(
                    data: uniqueCode,
                    version: QrVersions.auto,
                    size: 300.0,
                    gapless: false,
                    errorStateBuilder: (context, error) => const Center(
                      child: Text(
                        'Error al generar el QR',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Código: $uniqueCode',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  //boton para ir a MenuClient

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuClient(),
                        ),
                      );
                    },
                    child: const Text('Volver al menú'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
