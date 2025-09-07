import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/kyc/presentation/screens/kyc_upload_screen.dart';
import '../../features/kyc/presentation/screens/aadhaar_verify_screen.dart';
import '../../features/dashboard/presentation/screens/buyer_dashboard.dart';
import '../../features/dashboard/presentation/screens/seller_dashboard.dart';
import '../../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../../features/marketplace/presentation/screens/credit_detail_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/certificates/presentation/screens/certificates_screen.dart';
import '../providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isKYCApproved = authState.user?.kycStatus == 'approved';
      
      // Redirect unauthenticated users to landing
      if (!isAuthenticated && state.matchedLocation != '/login' && state.matchedLocation != '/register') {
        return '/';
      }
      
      // Redirect authenticated users without KYC to KYC flow
      if (isAuthenticated && !isKYCApproved && !state.matchedLocation.startsWith('/kyc')) {
        return '/kyc/upload';
      }
      
      return null;
    },
    routes: [
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
    ],
  );
});
