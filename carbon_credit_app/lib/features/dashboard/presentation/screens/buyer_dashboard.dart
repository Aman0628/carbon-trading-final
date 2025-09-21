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
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: _buildSidebar(context, ref, user),
      body: SafeArea(
        child: Column(
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
                            'Compliance',
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
                  hintText: 'Search carbon credits, projects...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
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
            
            // Dashboard Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 20),
            
                  ],
                ),
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
                    'Compliance',
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
                      'User ID: BC${user.email.hashCode.abs().toString().substring(0, 6)}',
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
          'User BC847291 bought 150 EXC worth 45 Carbon Credits',
          'User BC392847 sold 200 EXC worth 60 Carbon Credits',
          'User BC758392 bought 75 EXC worth 22 Carbon Credits',
          'User BC194857 sold 300 EXC worth 90 Carbon Credits',
          'User BC647382 bought 120 EXC worth 36 Carbon Credits',
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
}
