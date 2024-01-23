import 'package:bscb/screens/qr_details.dart';
import 'package:bscb/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'entry_confirmation_screen.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({
    super.key,
  });

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String qrCodeId;
  bool isDetailsPageOpened = false;

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text('QR SCANNER'),
        foregroundColor: Colors.grey.shade400,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            left: screenWidth * .197,
            top: 200,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.blue.shade300),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      String scannedCode = scanData.code!; //qr xodeeee

      if (!isDetailsPageOpened) {
        isDetailsPageOpened = true;

        bool entryExists =
            await _firebaseService.isQREntryAlreadyExists(scannedCode);

        if (!entryExists) {
          // Stop scanning after detecting one QR code
          controller.pauseCamera();

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EntryConfirmationScreen(
                qrCodeId: scannedCode,
                onConfirmed: (name, phoneNumber) async {
                  await _firebaseService.saveQREntry(
                    qrCodeId: scannedCode,
                    name: name,
                    phone: phoneNumber,
                  );

                  // Resume scanning if needed
                  controller.resumeCamera();

                  // Close EntryConfirmationScreen
                  Navigator.pop(context);

                  // Close QRScanScreen
                  Navigator.pop(context);
                },
              ),
            ),
          );
        } else {
          var details = await FirebaseService.getFullDetails(scannedCode);

          if (details.isNotEmpty) {
            // Stop scanning after detecting one QR code
            controller.pauseCamera();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRDetailsPage(
                  details: details,
                ),
              ),
            ).then((_) {
              // Resume scanning when QRDetailsPage is closed
              controller.resumeCamera();
              isDetailsPageOpened = false;
            });
          } else {
            // Handle the case when details are not found
            print('Details not found for QR code: $scannedCode');
          }
        }
      }
    });
  }
}
