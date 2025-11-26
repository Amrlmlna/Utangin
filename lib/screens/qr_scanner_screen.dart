import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // The callback for when a QR code is scanned
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        result = barcode;
        // Process the scanned result (likely an agreement ID)
        _processScannedResult(barcode.code ?? '');
      });
    });
  }

  void _processScannedResult(String scannedCode) {
    // The scanned code likely contains agreement information
    // We'll process it and navigate to confirmation screen
    Navigator.of(context).pop(scannedCode);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Agreement QR Code'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).colorScheme.primary,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (result != null)
                    Text(
                      'Scanning: ${result!.code}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    const Text('Scan an agreement QR code'),
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.pauseCamera();
                      // Add functionality to manually enter agreement ID
                      _showManualEntryDialog();
                    },
                    child: const Text('Enter Manually'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.flipCamera();
                    },
                    child: const Text('Flip Camera'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showManualEntryDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Agreement ID'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Agreement ID',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  _processScannedResult(controller.text);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}