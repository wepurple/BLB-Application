import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BLBQrScanner extends StatefulWidget {
  const BLBQrScanner({ Key? key }) : super(key: key);

  @override
  _BLBQrScannerState createState() => _BLBQrScannerState();
}

class _BLBQrScannerState extends State<BLBQrScanner> {

  final qrScannerKey = GlobalKey(debugLabel: 'QRScanner');
  QRViewController? controller;
  Barcode? barcode;

  // Méthode de remontage après redémarrage à chaud //
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.pauseCamera();
    }
  }

  // Permission d'ouvrir la camera //
  set permissionGranted(bool permissionGranted) {}
  Future permissionCamera() async {
    if (Platform.isIOS || Platform.isAndroid) {
      if (await Permission.camera.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.camera.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.camera.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).hintColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        title: const Text('Scanner de QR codes'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(
            bottom: 30,
            child: buildQrResult()
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
    key: qrScannerKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderLength: 15,
      borderWidth: 10,
      borderRadius: 10,
      borderColor: Theme.of(context).primaryColor,
      cutOutSize: MediaQuery.of(context).size.width * 0.65,
      cutOutBottomOffset: MediaQuery.of(context).size.height * 0.1,
    ),
  );

  Widget buildQrResult() => Container(
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).primaryColor,
    ),
    child: Center(
      child: Text(
        barcode != null ? '${barcode!.code}' : 'Aucun QR code détecté',
        style: TextStyle(
          color: Theme.of(context).hintColor
        ),
        maxLines: 10,
      ),
    ),
  );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) => setState(() => this.barcode = barcode));
  }

}