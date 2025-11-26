import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/agreement.dart';
import '../services/main_provider.dart';
import 'create_agreement_screen.dart';
import 'agreement_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch agreements when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mainProvider = Provider.of<MainProvider>(context, listen: false);
      if (mainProvider.auth.user != null) {
        mainProvider.agreement.fetchAgreements(mainProvider.auth.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    final user = mainProvider.auth.user;
    final agreements = mainProvider.agreement.agreements;

    // Calculate summary statistics
    double totalLoaned = agreements
        .where((agreement) => agreement.lenderId == user?.id)
        .fold(0, (sum, agreement) => sum + agreement.amount);
        
    double totalBorrowed = agreements
        .where((agreement) => agreement.borrowerId == user?.id)
        .fold(0, (sum, agreement) => sum + agreement.amount);
        
    int activeAgreements = agreements
        .where((agreement) => 
            agreement.status == AgreementStatus.active || 
            agreement.status == AgreementStatus.overdue)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UTANGIN Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications screen
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.account_circle),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
                onTap: () async {
                  await mainProvider.auth.logout();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (user != null) {
            await mainProvider.agreement.fetchAgreements(user.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Welcome, ${user?.name ?? "User"}!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Loaned',
                      'Rp ${totalLoaned.toStringAsFixed(0)}',
                      Icons.arrow_upward,
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Borrowed',
                      'Rp ${totalBorrowed.toStringAsFixed(0)}',
                      Icons.arrow_downward,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Active Agreements',
                      activeAgreements.toString(),
                      Icons.assignment,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSummaryCard(
                      'Reputation',
                      user?.reputationScore.toString() ?? '0',
                      Icons.star,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Recent agreements section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Agreements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all agreements screen
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              // Agreement list
              Expanded(
                child: agreements.isEmpty
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
                            const Text(
                              'No agreements yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateAgreementScreen(),
                                  ),
                                );
                              },
                              child: const Text('Create your first agreement'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: agreements.length > 5 ? 5 : agreements.length,
                        itemBuilder: (context, index) {
                          final agreement = agreements[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: agreement.status == AgreementStatus.active
                                    ? Colors.green
                                    : agreement.status == AgreementStatus.overdue
                                        ? Colors.red
                                        : Colors.grey,
                                child: agreement.lenderId == user?.id
                                    ? const Icon(Icons.arrow_upward, color: Colors.white)
                                    : const Icon(Icons.arrow_downward, color: Colors.white),
                              ),
                              title: Text(
                                agreement.lenderId == user?.id
                                    ? 'You lent to ${agreement.borrowerId}'
                                    : 'You borrowed from ${agreement.lenderId}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Rp ${agreement.amount.toStringAsFixed(0)} • ${agreement.dueDate.toLocal().toString().split(' ')[0]}',
                              ),
                              trailing: Text(
                                agreement.status.toString().split('.').last,
                                style: TextStyle(
                                  color: agreement.status == AgreementStatus.active
                                      ? Colors.green
                                      : agreement.status == AgreementStatus.overdue
                                          ? Colors.red
                                          : Colors.grey,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AgreementDetailScreen(agreement: agreement),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAgreementScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}