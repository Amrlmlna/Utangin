import 'package:flutter/material.dart';
import '../models/agreement.dart';

class AgreementListItem extends StatelessWidget {
  final Agreement agreement;
  final VoidCallback onTap;
  final String currentUserId;

  const AgreementListItem({
    super.key,
    required this.agreement,
    required this.onTap,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    bool isLender = agreement.lenderId == currentUserId;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(agreement.status),
          child: Icon(
            isLender ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(
          isLender
              ? 'You lent to ${agreement.borrowerId}'
              : 'You borrowed from ${agreement.lenderId}',
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Rp ${agreement.amount.toStringAsFixed(0)} • ${agreement.dueDate.toLocal().toString().split(' ')[0]}',
        ),
        trailing: Text(
          _formatStatus(agreement.status),
          style: TextStyle(
            color: _getStatusColor(agreement.status),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(AgreementStatus status) {
    switch (status) {
      case AgreementStatus.active:
        return Colors.green;
      case AgreementStatus.overdue:
        return Colors.red;
      case AgreementStatus.paid:
        return Colors.blue;
      case AgreementStatus.pending:
        return Colors.grey;
      case AgreementStatus.disputed:
        return Colors.orange;
    }
  }

  String _formatStatus(AgreementStatus status) {
    return status.toString().split('.').last.toUpperCase();
  }
}