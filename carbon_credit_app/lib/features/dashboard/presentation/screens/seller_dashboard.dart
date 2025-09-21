import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';

class SellerDashboard extends ConsumerWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user!;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: _buildSidebar(context, ref, user),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left side - Name and Role (Clickable)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: AppTextStyles.heading3.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Project Developer',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Right side - EXC Coins only
                  GestureDetector(
                    onTap: () => context.go('/wallet'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '2,450 EXC',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search carbon credits...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ),
            
            // Live Trading Marquee
            Container(
              height: 40,
              color: AppColors.primary.withOpacity(0.1),
              child: _buildTradingMarquee(),
            ),
            const SizedBox(height: 20),
            
            // Inventory Overview
            Text(
              'Inventory Overview',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    'Total Credits',
                    '4,300',
                    Icons.inventory,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    'Credits Sold',
                    '1,250',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    'Revenue',
                    '₹9,37,500',
                    Icons.account_balance_wallet,
                    AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    'Active Listings',
                    '3',
                    Icons.list_alt,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    icon: Icons.add,
                    title: 'Create Listing',
                    subtitle: 'List new credits',
                    onTap: () => _showCreateListingDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    icon: Icons.analytics,
                    title: 'View Analytics',
                    subtitle: 'Sales insights',
                    onTap: () => _showAnalyticsDialog(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Active Listings
            Text(
              'Active Listings',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _buildListingItem(
                    'Solar Farm Maharashtra',
                    '1,500 credits available',
                    '₹850/credit',
                    'Active',
                    AppColors.success,
                  ),
                  const Divider(height: 1),
                  _buildListingItem(
                    'Wind Energy Gujarat',
                    '800 credits available',
                    '₹920/credit',
                    'Active',
                    AppColors.success,
                  ),
                  const Divider(height: 1),
                  _buildListingItem(
                    'Reforestation Himachal',
                    '2,000 credits available',
                    '₹650/credit',
                    'Active',
                    AppColors.success,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, user) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: AppTextStyles.heading3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Project Developer',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'User ID: PD${user.email.hashCode.abs().toString().substring(0, 6)}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  icon: Icons.payment,
                  title: 'Payment Options',
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  icon: Icons.explore,
                  title: 'Explore',
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  icon: Icons.account_balance,
                  title: 'Govt Schemes',
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  icon: Icons.newspaper,
                  title: 'News',
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  icon: Icons.public,
                  title: 'International Market',
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(authProvider.notifier).logout();
                    context.go('/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildTradingMarquee() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 2), (i) => i),
      builder: (context, snapshot) {
        final transactions = [
          'User PD847291 sold 150 EXC worth 45 Carbon Credits',
          'User BC392847 bought 200 EXC worth 60 Carbon Credits',
          'User PD758392 sold 75 EXC worth 22 Carbon Credits',
          'User BC194857 bought 300 EXC worth 90 Carbon Credits',
          'User PD647382 sold 120 EXC worth 36 Carbon Credits',
        ];
        
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              transactions[(snapshot.data ?? 0) % transactions.length],
              key: ValueKey(snapshot.data ?? 0),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListingItem(
    String title,
    String subtitle,
    String price,
    String status,
    Color statusColor,
  ) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.eco, color: Colors.white),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMedium),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            price,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: AppTextStyles.caption.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateListingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Listing'),
        content: const Text(
          'This feature will allow you to create new carbon credit listings. '
          'In the full version, this would open a detailed form to enter project details, '
          'certification information, and pricing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Coming Soon'),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sales Analytics'),
        content: const Text(
          'This feature will show detailed analytics including:\n\n'
          '• Sales performance over time\n'
          '• Revenue trends\n'
          '• Popular credit types\n'
          '• Market price comparisons\n'
          '• Buyer demographics',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Coming Soon'),
          ),
        ],
      ),
    );
  }
}
