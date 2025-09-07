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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/');
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${user.name}!',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage your carbon credit listings',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
