import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../tools/presentation/screens/tools_screen.dart';
import '../../../tools/presentation/screens/carbon_calculator_screen.dart' as calc;
import '../../../tools/presentation/screens/market_news_screen.dart' as news;
import '../../../marketplace/presentation/screens/seller_marketplace_screen.dart';

class SellerDashboard extends ConsumerStatefulWidget {
  const SellerDashboard({super.key});

  @override
  ConsumerState<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends ConsumerState<SellerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTransactionIndex = 0;
  Timer? _transactionTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> _recentSales = [
    {
      'buyerName': 'Green Corp Ltd',
      'credits': '50 credits',
      'projectName': 'Solar Farm Maharashtra',
      'amount': '₹42,500',
      'time': '2 minutes ago',
      'type': 'Sale'
    },
    {
      'buyerName': 'EcoTech Solutions',
      'credits': '25 credits',
      'projectName': 'Wind Energy Gujarat',
      'amount': '₹23,000',
      'time': '5 minutes ago',
      'type': 'Sale'
    },
    {
      'buyerName': 'Sustainable Industries',
      'credits': '75 credits',
      'projectName': 'Reforestation Himachal',
      'amount': '₹48,750',
      'time': '8 minutes ago',
      'type': 'Sale'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _startTransactionTimer();
  }

  @override
  void dispose() {
    _transactionTimer?.cancel();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 0) {
      _startTransactionTimer();
    } else {
      _stopTransactionTimer();
    }
  }

  void _startTransactionTimer() {
    if ((_transactionTimer == null || !_transactionTimer!.isActive) && _tabController.index == 0) {
      _transactionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_scaffoldKey.currentState?.isDrawerOpen == false) {
          setState(() {
            _currentTransactionIndex = (_currentTransactionIndex + 1) % _recentSales.length;
          });
        }
      });
    }
  }

  void _stopTransactionTimer() {
    _transactionTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user!;

    return Scaffold(
      key: _scaffoldKey,
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
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
                  hintText: 'Search projects, credits, buyers...',
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
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
                Tab(text: 'My Projects', icon: Icon(Icons.eco)),
                Tab(text: 'Tools', icon: Icon(Icons.build)),
              ],
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard View
                  _buildDashboardView(),
                  
                  // My Projects View
                  _buildProjectsView(),
                  
                  // Tools View
                  _buildToolsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inventory Overview
          Text(
            'Inventory Overview',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(1); // Navigate to My Projects tab
                  },
                  child: _buildStatsCard(
                    'My Projects',
                    '5',
                    Icons.eco,
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SellerMarketplaceScreen(),
                      ),
                    );
                  },
                  child: _buildStatsCard(
                    'Marketplace',
                    '1,250',
                    Icons.store,
                    AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Total Available Credits',
                  '4,300',
                  Icons.inventory,
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
          const SizedBox(height: 24),

          // Recent Sales Section
          Text(
            'Recent Sales',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildRecentSaleItem(
              _recentSales[_currentTransactionIndex],
              key: ValueKey(_currentTransactionIndex),
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Actions',
                style: AppTextStyles.heading3,
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ToolsScreen(),
                  ),
                ),
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildActionCard(
                context: context,
                icon: Icons.add,
                title: 'Create Listing',
                subtitle: 'List new credits',
                onTap: () => _showCreateListingDialog(context),
              ),
              _buildActionCard(
                context: context,
                icon: Icons.calculate,
                title: 'Carbon Calculator',
                subtitle: 'Calculate emissions',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const calc.CarbonCalculatorScreen(),
                  ),
                ),
              ),
              _buildActionCard(
                context: context,
                icon: Icons.insights,
                title: 'Market News',
                subtitle: 'Latest trends',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const news.MarketNewsScreen(),
                  ),
                ),
              ),
              _buildActionCard(
                context: context,
                icon: Icons.analytics,
                title: 'View Analytics',
                subtitle: 'Sales insights',
                onTap: () => _showAnalyticsDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Active Projects',
                  '3',
                  Icons.eco,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatsCard(
                  'Total Capacity',
                  '4,300',
                  Icons.battery_charging_full,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Active Projects
          Text(
            'Active Projects',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildProjectItem(
                  'Solar Farm Maharashtra',
                  'Renewable Energy • 1,500 credits',
                  '₹850/credit',
                  'Active',
                  AppColors.success,
                  Icons.wb_sunny,
                ),
                const Divider(height: 1),
                _buildProjectItem(
                  'Wind Energy Gujarat',
                  'Renewable Energy • 800 credits',
                  '₹920/credit',
                  'Active',
                  AppColors.success,
                  Icons.air,
                ),
                const Divider(height: 1),
                _buildProjectItem(
                  'Reforestation Himachal',
                  'Forestry • 2,000 credits',
                  '₹650/credit',
                  'Active',
                  AppColors.success,
                  Icons.forest,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Add New Project Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCreateProjectDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add New Project'),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildToolsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seller Tools & Resources',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 8),
          Text(
            'Essential tools for carbon credit sellers',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Tools Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildToolCard(
                'Project Calculator',
                'Calculate project viability',
                Icons.calculate,
                AppColors.primary,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const calc.CarbonCalculatorScreen(),
                  ),
                ),
              ),
              _buildToolCard(
                'Market Insights',
                'Latest market trends',
                Icons.insights,
                AppColors.info,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const news.MarketNewsScreen(),
                  ),
                ),
              ),
              _buildToolCard(
                'Pricing Tool',
                'Optimize your pricing',
                Icons.price_change,
                AppColors.success,
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pricing tool coming soon!')),
                ),
              ),
              _buildToolCard(
                'Compliance Check',
                'Verify project compliance',
                Icons.verified_user,
                AppColors.warning,
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compliance check coming soon!')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // View All Tools Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ToolsScreen(),
                ),
              ),
              icon: const Icon(Icons.build),
              label: const Text('View All Tools'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, user) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Menu',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
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
                // Account Section
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Account',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/account');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Wallet',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/wallet');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.payment,
                  title: 'Payment Options',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/payment-options');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.shopping_bag,
                  title: 'Orders',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/orders');
                  },
                ),
                const Divider(),
                
                // Seller Features
                _buildMenuItem(
                  icon: Icons.eco,
                  title: 'My Projects',
                  onTap: () {
                    Navigator.pop(context);
                    _tabController.animateTo(1);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.store,
                  title: 'Marketplace',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SellerMarketplaceScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                
                // Additional Features
                _buildMenuItem(
                  icon: Icons.account_balance,
                  title: 'Govt Schemes',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Government schemes coming soon!')),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.newspaper,
                  title: 'News',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('News section coming soon!')),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.public,
                  title: 'International Market',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('International market coming soon!')),
                    );
                  },
                ),
                const Divider(),
                
                // Settings & Support
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.contact_support,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/contact-us');
                  },
                ),
                const Divider(),
                
                // Logout
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

  // New helper methods for seller dashboard
  Widget _buildRecentSaleItem(Map<String, String> sale, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: () => _showSaleDetails(sale),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.success.withOpacity(0.1),
                child: Icon(Icons.trending_up, color: AppColors.success),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: sale['buyerName']!,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' bought '),
                          TextSpan(
                            text: sale['credits']!,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'from ${sale['projectName']!}',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      sale['time']!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sale['amount']!,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectItem(String title, String subtitle, String price, String status, Color statusColor, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(icon, color: statusColor),
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
      onTap: () => _showProjectDetails(title),
    );
  }


  Widget _buildToolCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Project'),
        content: const Text(
          'This feature will allow you to add new carbon credit projects. '
          'You can specify project details, upload documentation, and set pricing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Coming Soon'),
          ),
        ],
      ),
    );
  }

  void _showSaleDetails(Map<String, String> sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sale Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Buyer', sale['buyerName']!),
            _buildDetailRow('Credits', sale['credits']!),
            _buildDetailRow('Project', sale['projectName']!),
            _buildDetailRow('Amount', sale['amount']!),
            _buildDetailRow('Time', sale['time']!),
            _buildDetailRow('Type', sale['type']!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(projectName),
        content: const Text(
          'Project details including certification status, '
          'available credits, pricing history, and buyer feedback.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('View Full Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
