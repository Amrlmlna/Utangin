import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/agreement.dart';

class QRCreationScreen extends StatefulWidget {
  final Agreement agreement;
  const QRCreationScreen({super.key, required this.agreement});

  @override
  State<QRCreationScreen> createState() => _QRCreationScreenState();
}

class _QRCreationScreenState extends State<QRCreationScreen> {
  @override
  Widget build(BuildContext context) {
    // Create QR code data containing agreement info
    String qrData = 'UTANGIN_AGREEMENT:${widget.agreement.id}:${widget.agreement.lenderId}:${widget.agreement.borrowerId}:${widget.agreement.amount}:${widget.agreement.dueDate.toIso8601String()}';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agreement QR Code'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(77, 128, 128, 128), // This is equivalent to Colors.grey.withOpacity(0.3)
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Show this QR code to the other party to confirm the agreement',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Agreement Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow('Agreement ID:', widget.agreement.id),
                    _buildDetailRow('Amount:', 'Rp ${widget.agreement.amount.toStringAsFixed(0)}'),
                    _buildDetailRow('Due Date:', widget.agreement.dueDate.toLocal().toString().split(' ')[0]),
                    _buildDetailRow('Status:', widget.agreement.status.toString().split('.').last),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Back to Agreement'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}