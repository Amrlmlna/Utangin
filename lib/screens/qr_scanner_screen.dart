import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  void _onDetect(BarcodeCapture barcodes) {
    final String code = barcodes.barcodes.first.rawValue ?? '';
    if (code.isNotEmpty) {
      _processScannedResult(code);
    }
  }

  void _processScannedResult(String scannedCode) {
    // The scanned code likely contains agreement information
    // We'll process it and navigate to confirmation screen
    cameraController.dispose();  // Dispose before navigating
    Navigator.of(context).pop(scannedCode);
  }

  @override
  void dispose() {
    cameraController.dispose();
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
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Add functionality to manually enter agreement ID
                    _showManualEntryDialog();
                  },
                  child: const Text('Enter Manually'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Toggle torch
                    cameraController.toggleTorch();
                  },
                  child: const Text('Toggle Flash'),
                ),
              ],
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