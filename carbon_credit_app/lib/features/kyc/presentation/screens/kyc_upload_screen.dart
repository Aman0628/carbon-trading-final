import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

class KYCUploadScreen extends ConsumerStatefulWidget {
  const KYCUploadScreen({super.key});

  @override
  ConsumerState<KYCUploadScreen> createState() => _KYCUploadScreenState();
}

class _KYCUploadScreenState extends ConsumerState<KYCUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _aadhaarFront;
  XFile? _aadhaarBack;
  bool _isUploading = false;

  Future<void> _pickImage(bool isFront) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    
    if (image != null) {
      setState(() {
        if (isFront) {
          _aadhaarFront = image;
        } else {
          _aadhaarBack = image;
        }
      });
    }
  }

  Future<void> _uploadDocuments() async {
    if (_aadhaarFront == null || _aadhaarBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture both front and back of Aadhaar card'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final apiService = ApiService();
      
      // Upload front image
      await apiService.uploadKYCDocument('aadhaar_front', _aadhaarFront!.path);
      
      // Upload back image
      await apiService.uploadKYCDocument('aadhaar_back', _aadhaarBack!.path);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documents uploaded successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        context.go('/kyc/aadhaar-verify');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Upload Aadhaar Card',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please capture clear photos of both sides of your Aadhaar card',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Front Side Upload
              _buildUploadCard(
                title: 'Aadhaar Front Side',
                subtitle: 'Capture the front side with your photo',
                image: _aadhaarFront,
                onTap: () => _pickImage(true),
              ),
              const SizedBox(height: 16),
              
              // Back Side Upload
              _buildUploadCard(
                title: 'Aadhaar Back Side',
                subtitle: 'Capture the back side with address',
                image: _aadhaarBack,
                onTap: () => _pickImage(false),
              ),
              const SizedBox(height: 32),
              
              // Security Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.security,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your data is secure',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'All documents are encrypted and stored securely. We comply with Indian data protection laws.',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              // Upload Button
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadDocuments,
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Uploading...'),
                        ],
                      )
                    : const Text('Upload Documents'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required XFile? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: image != null ? AppColors.success : AppColors.divider,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: image != null ? AppColors.success.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
        ),
        child: image != null
            ? Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.success.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 32,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Captured successfully',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.success,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
    );
  }
}
