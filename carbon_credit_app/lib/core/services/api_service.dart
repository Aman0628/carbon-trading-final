import 'dart:convert';
import 'dart:math';
import '../models/user.dart';
import '../models/credit_listing.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Mock data for demonstration
  final List<CreditListing> _mockListings = [
    CreditListing(
      id: '1',
      projectName: 'Solar Farm Maharashtra',
      description: 'Large-scale solar energy project reducing CO2 emissions by 50,000 tons annually',
      projectType: 'Renewable Energy',
      location: 'Maharashtra, India',
      pricePerCredit: 850.0,
      availableCredits: 1500,
      certificationBody: 'Verra',
      certificationStandard: 'VCS',
      vintageYear: DateTime(2023),
      sellerId: 'seller1',
      sellerName: 'GreenTech Solutions',
      images: ['https://example.com/solar1.jpg'],
      projectDetails: {
        'capacity': '100 MW',
        'annual_generation': '180 GWh',
        'co2_reduction': '50,000 tons/year'
      },
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      status: 'active',
    ),
    CreditListing(
      id: '2',
      projectName: 'Reforestation Himachal',
      description: 'Community-based reforestation project planting native species',
      projectType: 'Forestry',
      location: 'Himachal Pradesh, India',
      pricePerCredit: 650.0,
      availableCredits: 2000,
      certificationBody: 'Verra',
      certificationStandard: 'VCS',
      vintageYear: DateTime(2023),
      sellerId: 'seller2',
      sellerName: 'Forest Revival Co.',
      images: ['https://example.com/forest1.jpg'],
      projectDetails: {
        'area': '500 hectares',
        'trees_planted': '100,000',
        'co2_sequestration': '25,000 tons/year'
      },
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      status: 'active',
    ),
    CreditListing(
      id: '3',
      projectName: 'Wind Energy Gujarat',
      description: 'Offshore wind farm generating clean electricity',
      projectType: 'Renewable Energy',
      location: 'Gujarat, India',
      pricePerCredit: 920.0,
      availableCredits: 800,
      certificationBody: 'Verra',
      certificationStandard: 'VCS',
      vintageYear: DateTime(2024),
      sellerId: 'seller3',
      sellerName: 'WindPower India',
      images: ['https://example.com/wind1.jpg'],
      projectDetails: {
        'capacity': '150 MW',
        'annual_generation': '400 GWh',
        'co2_reduction': '75,000 tons/year'
      },
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      status: 'active',
    ),
  ];

  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock successful login
    if (email.isNotEmpty && password.length >= 6) {
      return {
        'success': true,
        'user': {
          'id': 'user123',
          'email': email,
          'name': 'John Doe',
          'role': 'buyer',
          'kyc_status': 'approved',
          'created_at': DateTime.now().toIso8601String(),
        },
        'token': 'mock_jwt_token_${Random().nextInt(1000)}',
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid credentials',
      };
    }
  }

  Future<Map<String, dynamic>> register(String email, String password, String name, UserRole role) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'user': {
        'id': 'user${Random().nextInt(1000)}',
        'email': email,
        'name': name,
        'role': role.toString().split('.').last,
        'kyc_status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      },
      'token': 'mock_jwt_token_${Random().nextInt(1000)}',
    };
  }

  Future<List<CreditListing>> getListings({
    String? projectType,
    String? location,
    double? minPrice,
    double? maxPrice,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    var filteredListings = _mockListings.where((listing) {
      if (projectType != null && listing.projectType != projectType) return false;
      if (location != null && !listing.location.toLowerCase().contains(location.toLowerCase())) return false;
      if (minPrice != null && listing.pricePerCredit < minPrice) return false;
      if (maxPrice != null && listing.pricePerCredit > maxPrice) return false;
      return true;
    }).toList();
    
    return filteredListings;
  }

  Future<CreditListing?> getListingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _mockListings.firstWhere((listing) => listing.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> uploadKYCDocument(String documentType, String filePath) async {
    await Future.delayed(const Duration(seconds: 3));
    
    return {
      'success': true,
      'message': 'Document uploaded successfully',
      'document_id': 'doc_${Random().nextInt(1000)}',
    };
  }

  Future<Map<String, dynamic>> verifyAadhaar(String aadhaarNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock verification logic
    if (aadhaarNumber.length == 12 && otp == '123456') {
      return {
        'success': true,
        'message': 'Aadhaar verified successfully',
        'kyc_status': 'approved',
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid OTP or Aadhaar number',
      };
    }
  }

  Future<Map<String, dynamic>> processCheckout(List<Map<String, dynamic>> items, String paymentMethod) async {
    await Future.delayed(const Duration(seconds: 3));
    
    double totalAmount = items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
    
    return {
      'success': true,
      'transaction_id': 'txn_${Random().nextInt(10000)}',
      'amount': totalAmount,
      'message': 'Payment processed successfully',
    };
  }
}
