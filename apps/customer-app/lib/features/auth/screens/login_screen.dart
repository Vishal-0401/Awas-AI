import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/route_paths.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handlePhoneLogin() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await ref.read(authProvider.notifier).sendOtp(_phoneController.text);
      if (mounted) {
        setState(() => _isLoading = false);
        context.push(RoutePaths.otp);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);

        // Prefer clean message; ApiException.toString() may include extra info.
        final msg = e is Exception ? e.toString() : 'Request failed';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.error),
        );
      }
    }

  }

  void _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
      // Navigation is handled by GoRouter's redirect based on authState
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              
              // Glowing Logo / Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                       color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sensors_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
              
              const SizedBox(height: 40),
              
              Text(
                'Welcome to\nAWAS Home',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  height: 1.2,
                  color: Colors.white,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 12),
              
              Text(
                'Enter your mobile number to continue securely.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 48),
              
              // Mobile Number Input
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('+91', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Container(width: 1, height: 24, color: Colors.white24),
                        ],
                      ),
                    ),
                    hintText: '00000 00000',
                    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), letterSpacing: 2),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 40),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading || _isGoogleLoading ? null : _handlePhoneLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Continue'),
                ),
              ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
              
              const SizedBox(height: 24),
              
              // Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ).animate().fadeIn(delay: 900.ms),
              
              const SizedBox(height: 24),
              
              // Google Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _isLoading || _isGoogleLoading ? null : _handleGoogleLogin,
                  icon: _isGoogleLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.g_mobiledata_rounded, size: 32, color: Colors.white),
                  label: const Text('Continue with Google', style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),

              const SizedBox(height: 32),
              
              // Terms & Conditions
              Center(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(delay: 1100.ms),
            ],
          ),
        ),
      ),
    );
  }
}
