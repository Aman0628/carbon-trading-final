import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/cart_provider.dart';

class BuyerDashboard extends ConsumerWidget {
  const BuyerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final cartState = ref.watch(cartProvider);
    final user = authState.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cartState.itemCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => context.go('/cart'),
          ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                                'Welcome back, ${user.name}!',
                                style: AppTextStyles.heading3,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ready to offset your carbon footprint?',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                    icon: Icons.store,
                    title: 'Browse Credits',
                    subtitle: 'Find carbon credits',
                    onTap: () => context.go('/marketplace'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    icon: Icons.card_membership,
                    title: 'My Certificates',
                    subtitle: 'View portfolio',
                    onTap: () => context.go('/certificates'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Market Insights
            Text(
              'Market Insights',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInsightRow(
                      'Average Price',
                      '₹750/credit',
                      Icons.trending_up,
                      AppColors.success,
                    ),
                    const Divider(),
                    _buildInsightRow(
                      'Active Listings',
                      '1,247',
                      Icons.inventory,
                      AppColors.info,
                    ),
                    const Divider(),
                    _buildInsightRow(
                      'Credits Traded Today',
                      '3,456',
                      Icons.swap_horiz,
                      AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Recent Activity
            Text(
              'Recent Activity',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _buildActivityItem(
                    'Purchased 50 credits',
                    'Solar Farm Maharashtra',
                    '2 days ago',
                    Icons.shopping_bag,
                    AppColors.success,
                  ),
                  const Divider(height: 1),
                  _buildActivityItem(
                    'Retired 25 credits',
                    'Wind Energy Gujarat',
                    '1 week ago',
                    Icons.eco,
                    AppColors.primary,
                  ),
                  const Divider(height: 1),
                  _buildActivityItem(
                    'Added to cart',
                    'Reforestation Himachal',
                    '2 weeks ago',
                    Icons.add_shopping_cart,
                    AppColors.warning,
                  ),
                ],
              ),
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
              Icon(
                icon,
                size: 32,
                color: AppColors.primary,
              ),
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

  Widget _buildInsightRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMedium),
      trailing: Text(time, style: AppTextStyles.caption),
    );
  }
}
