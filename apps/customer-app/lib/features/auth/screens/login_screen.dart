import 'package:awas_customer_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/route_paths.dart';
import '../providers/auth_provider.dart';

enum LoginType { mobile, email }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isCreateAccount = false;

  LoginType _loginType = LoginType.mobile;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final value = _controller.text.trim();

    if (_loginType == LoginType.mobile) {
      if (value.length < 10) {
        _showError('Enter valid mobile number');
        return;
      }
    } else {
      if (!value.contains('@')) {
        _showError('Enter valid email');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      if (_loginType == LoginType.mobile) {
        await ref.read(authProvider.notifier).sendOtp(value);
      } else {
        await ref.read(authProvider.notifier).sendEmailOtp(value);
      }

      if (mounted) {
        setState(() => _isLoading = false);

        context.push(
          RoutePaths.otp,
          extra: {
            "value": value,
            "type": _loginType.name,
          },
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);

    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
    } catch (e) {
      _showError(e.toString());
    }

    setState(() => _isGoogleLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 50),

              // Logo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 30,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: AppColors.primary,
                    size: 45,
                  ),
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 40),

              Text(
                _isCreateAccount
                    ? "Create\nAccount"
                    : "Welcome\nBack",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(),

              const SizedBox(height: 12),

              const Text(
                "Login securely using mobile number or email OTP.",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // Toggle Mobile / Email
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _loginType = LoginType.mobile;
                          _controller.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _loginType == LoginType.mobile
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "Mobile OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _loginType = LoginType.email;
                          _controller.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _loginType == LoginType.email
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "Email OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Input
              TextField(
                controller: _controller,
                keyboardType: _loginType == LoginType.mobile
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: _loginType == LoginType.mobile
                      ? "Enter mobile number"
                      : "Enter email address",
                  prefixIcon: Icon(
                    _loginType == LoginType.mobile
                        ? Icons.phone_android
                        : Icons.email_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading || _isGoogleLoading ? null : _handleContinue,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          _isCreateAccount
                              ? "Create Account"
                              : "Send OTP",
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Google Login
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: _handleGoogleLogin,
                  icon: _isGoogleLoading
                      ? const CircularProgressIndicator()
                      : const Icon(
                          Icons.g_mobiledata_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                  label: const Text(
                    "Continue with Google",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Create account toggle
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCreateAccount = !_isCreateAccount;
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _isCreateAccount
                              ? "Already have account? "
                              : "Don't have account? ",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const TextSpan(
                          text: "Create Account",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "By continuing you agree to Terms & Privacy Policy",
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}