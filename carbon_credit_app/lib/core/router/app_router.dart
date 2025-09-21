import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/waitlist_screen.dart';
import '../../features/kyc/presentation/screens/kyc_upload_screen.dart';
import '../../features/kyc/presentation/screens/aadhaar_verify_screen.dart';
import '../../features/dashboard/presentation/screens/buyer_dashboard.dart';
import '../../features/dashboard/presentation/screens/seller_dashboard.dart';
import '../../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../../features/marketplace/presentation/screens/credit_detail_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/certificates/presentation/screens/certificates_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/waitlist',
        builder: (context, state) => const WaitlistScreen(),
      ),
      GoRoute(
        path: '/kyc/upload',
        builder: (context, state) => const KYCUploadScreen(),
      ),
      GoRoute(
        path: '/kyc/aadhaar-verify',
        builder: (context, state) => const AadhaarVerifyScreen(),
      ),
      GoRoute(
        path: '/dashboard/buyer',
        builder: (context, state) => const BuyerDashboard(),
      ),
      GoRoute(
        path: '/dashboard/seller',
        builder: (context, state) => const SellerDashboard(),
      ),
      GoRoute(
        path: '/marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/marketplace/credit/:id',
        builder: (context, state) => CreditDetailScreen(
          creditId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/certificates',
        builder: (context, state) => const CertificatesScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
    ],
  );
});
