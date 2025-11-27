import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/agreement.dart';
import '../services/main_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/summary_card.dart';
import '../widgets/agreement_list_item.dart';
import 'create_agreement_screen.dart';
import 'agreement_detail_screen.dart';

class BottomNavDashboard extends StatefulWidget {
  const BottomNavDashboard({super.key});

  @override
  State<BottomNavDashboard> createState() => _BottomNavDashboardState();
}

class _BottomNavDashboardState extends State<BottomNavDashboard> {
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (String result) {
              if (result == 'logout') {
                _handleLogout(context);
              }
            },
            itemBuilder: (BuildContext context) => [
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
                child: const Text('Logout'),
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
        child: _buildDashboardContent(
          context,
          user,
          totalLoaned,
          totalBorrowed,
          activeAgreements,
          agreements,
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAgreementScreen(),
            ),
          );
        },
        icon: Icons.add,
        tooltip: 'Create Agreement',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Agreements',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    dynamic user,
    double totalLoaned,
    double totalBorrowed,
    int activeAgreements,
    List<Agreement> agreements,
  ) {
    return Padding(
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
                child: SummaryCard(
                  title: 'Total Loaned',
                  value: 'Rp ${totalLoaned.toStringAsFixed(0)}',
                  icon: Icons.arrow_upward,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'Total Borrowed',
                  value: 'Rp ${totalBorrowed.toStringAsFixed(0)}',
                  icon: Icons.arrow_downward,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Active Agreements',
                  value: activeAgreements.toString(),
                  icon: Icons.assignment,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'Reputation',
                  value: user?.reputationScore.toString() ?? '0',
                  icon: Icons.star,
                  color: Colors.green,
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
          Flexible(
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
                      return AgreementListItem(
                        agreement: agreement,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgreementDetailScreen(agreement: agreement),
                            ),
                          );
                        },
                        currentUserId: user?.id ?? '',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final navigator = Navigator.of(context); // Store navigator reference before async call
    await mainProvider.auth.logout();
    if (mounted) {
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}