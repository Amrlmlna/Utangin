import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/agreement.dart';
import '../services/main_provider.dart';
import 'agreement_detail_screen.dart';

class RepaymentTrackingScreen extends StatefulWidget {
  const RepaymentTrackingScreen({super.key});

  @override
  State<RepaymentTrackingScreen> createState() => _RepaymentTrackingScreenState();
}

class _RepaymentTrackingScreenState extends State<RepaymentTrackingScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    final user = mainProvider.auth.user;
    final agreements = mainProvider.agreement.agreements;

    List<Agreement> filteredAgreements = [];

    if (_currentTab == 0) {
      // All agreements
      filteredAgreements = agreements;
    } else if (_currentTab == 1) {
      // Active agreements
      filteredAgreements = agreements.where((agreement) => 
          agreement.status == AgreementStatus.active).toList();
    } else if (_currentTab == 2) {
      // Overdue agreements
      filteredAgreements = agreements.where((agreement) => 
          agreement.status == AgreementStatus.overdue).toList();
    } else if (_currentTab == 3) {
      // Completed agreements
      filteredAgreements = agreements.where((agreement) => 
          agreement.status == AgreementStatus.paid).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repayment Tracking'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Theme.of(context).colorScheme.onPrimary,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Active'),
                Tab(text: 'Overdue'),
                Tab(text: 'Completed'),
              ],
              onTap: (index) {
                setState(() {
                  _currentTab = index;
                });
              },
            ),
          ),
          // Agreement list
          Expanded(
            child: filteredAgreements.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 60,
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _currentTab == 0
                              ? 'No agreements yet'
                              : _currentTab == 1
                                  ? 'No active agreements'
                                  : _currentTab == 2
                                      ? 'No overdue agreements'
                                      : 'No completed agreements',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredAgreements.length,
                    itemBuilder: (context, index) {
                      final agreement = filteredAgreements[index];
                      bool isLender = user?.id == agreement.lenderId;
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          leading: CircleAvatar(
                            backgroundColor: agreement.status == AgreementStatus.active
                                ? Colors.green
                                : agreement.status == AgreementStatus.overdue
                                    ? Colors.red
                                    : agreement.status == AgreementStatus.paid
                                        ? Colors.blue
                                        : Colors.grey,
                            child: Icon(
                              isLender
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            isLender
                                ? 'You lent to ${agreement.borrowerId.substring(0, 8)}...'
                                : 'You borrowed from ${agreement.lenderId.substring(0, 8)}...',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${agreement.amount.toStringAsFixed(0)} • Due: ${agreement.dueDate.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                agreement.status.toString().split('.').last,
                                style: TextStyle(
                                  color: agreement.status == AgreementStatus.active
                                      ? Colors.green
                                      : agreement.status == AgreementStatus.overdue
                                          ? Colors.red
                                          : agreement.status == AgreementStatus.paid
                                              ? Colors.blue
                                              : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (agreement.status == AgreementStatus.overdue)
                                Text(
                                  'Overdue by ${DateTime.now().difference(agreement.dueDate).inDays} days',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AgreementDetailScreen(agreement: agreement),
                              ),
                            );
                          },
                          onLongPress: () {
                            _showAgreementActions(agreement, mainProvider);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAgreementActions(Agreement agreement, MainProvider mainProvider) {
    final user = mainProvider.auth.user;
    bool isLender = user?.id == agreement.lenderId;
    
    List<Widget> actions = [];
    
    if (agreement.status == AgreementStatus.active && !isLender) {
      // Borrower can mark as paid
      actions.add(
        ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.green),
          title: const Text('Mark as Paid'),
          onTap: () async {
            Navigator.pop(context); // Close the bottom sheet
            try {
              await mainProvider.agreement.markAgreementAsPaid(agreement.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment marked as completed')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          },
        ),
      );
    } else if (agreement.status == AgreementStatus.overdue && isLender) {
      // Lender can send reminder
      actions.add(
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.orange),
          title: const Text('Send Reminder'),
          onTap: () {
            Navigator.pop(context); // Close the bottom sheet
            // Implementation for sending reminder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reminder sent')),
            );
          },
        ),
      );
    }
    
    actions.add(
      ListTile(
        leading: const Icon(Icons.info, color: Colors.blue),
        title: const Text('View Details'),
        onTap: () {
          Navigator.pop(context); // Close the bottom sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgreementDetailScreen(agreement: agreement),
            ),
          );
        },
      ),
    );

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: actions,
          ),
        );
      },
    );
  }
}