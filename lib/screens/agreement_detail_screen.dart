import 'package:flutter/material.dart';
import '../models/agreement.dart';

class AgreementDetailScreen extends StatelessWidget {
  final Agreement agreement;
  const AgreementDetailScreen({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agreement Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Agreement status chip
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: agreement.status == AgreementStatus.active
                        ? Colors.green
                        : agreement.status == AgreementStatus.paid
                            ? Colors.blue
                            : agreement.status == AgreementStatus.overdue
                                ? Colors.red
                                : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    agreement.status.toString().split('.').last.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Agreement details
              Text(
                'Rp ${agreement.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Due Date: ${agreement.dueDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              
              // Lender and borrower info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Agreement Parties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, color: Colors.green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Lender',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Text(agreement.lenderId),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.account_balance, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Borrower',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Text(agreement.borrowerId),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Agreement terms
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Terms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Amount', 'Rp ${agreement.amount.toStringAsFixed(0)}'),
                      _buildDetailRow('Interest Rate', '${agreement.interestRate} %'),
                      _buildDetailRow('Due Date', agreement.dueDate.toLocal().toString().split(' ')[0]),
                      _buildDetailRow('Status', agreement.status.toString().split('.').last),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Confirmation status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirmation Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildConfirmationStatus('Lender', agreement.lenderConfirmed),
                      _buildConfirmationStatus('Borrower', agreement.borrowerConfirmed),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Action buttons
              if (agreement.status == AgreementStatus.pending)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Confirm agreement logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Confirm Agreement'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Generate QR code logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: const Text('QR Code'),
                      ),
                    ),
                  ],
                )
              else if (agreement.status == AgreementStatus.active)
                ElevatedButton(
                  onPressed: () {
                    // Mark as paid logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Mark as Paid'),
                )
              else if (agreement.status == AgreementStatus.overdue)
                ElevatedButton(
                  onPressed: () {
                    // Remind borrower logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Send Reminder'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStatus(String party, bool confirmed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            party,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: confirmed ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              confirmed ? 'Confirmed' : 'Pending',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}