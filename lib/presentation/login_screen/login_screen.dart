import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../services/chat_socket_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  void _checkBiometricAvailability() {
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await AuthService.login(email, password);

      final status = res["status"];
      final data = res["data"];

      // 🔥 1. BACKEND CUSTOM ERROR
      if (data["error"] != null) {
        setState(() {
          _errorMessage = data["error"];  // <-- SHOW PENDING / REJECTED MESSAGE
        });
        return;
      }

      // 🔥 2. SUCCESSFUL LOGIN

      if (status == 200 && data["token"] != null) {
        final token = data["token"];
        final astrologer = data["astrologer"];

        if (astrologer == null || astrologer["_id"] == null) {
          setState(() {
            _errorMessage = "Astrologer ID missing from server.";
          });
          return;
        }

        final astroId = astrologer["_id"].toString();

        // 1. Clear old data FIRST
        await StorageService.clear();

        // 2. Save new token + ID
        await StorageService.saveToken(token);
        await StorageService.saveAstrologerId(astroId);

        print("✔️ Saved new token: $token");
        print("✔️ Saved astrologerId: $astroId");

        // 3. Connect socket (safe try/catch)
        try {
           ChatSocketService.connect(id: astroId);
        } catch (e) {
          print("⚠️ Socket failed: $e");
        }

        // 4. Navigate — BUT return immediately after
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard-screen',
              (route) => false,
        );

        return;   // <-- THIS STOPS FALLING INTO THE ERROR MESSAGE BELOW
      }

      // 🔥 3. FALLBACK INVALID CREDENTIALS
      else {
        setState(() {
          _errorMessage = "Invalid email or password.";
        });
      }

    } catch (e) {
      print("LOGIN ERROR: $e");
      setState(() {
        _errorMessage = "Network error. Please try again.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8.h),
                    const AppLogoWidget(),
                    SizedBox(height: 6.h),

                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Sign in to manage your astrology consultations',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // ⭐ Error box
                    _errorMessage != null
                        ? Container(
                      margin: EdgeInsets.only(bottom: 3.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.error.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'error_outline',
                            color: theme.colorScheme.error,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme
                                    .colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),

                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    BiometricAuthWidget(
                      onBiometricLogin: () {},
                      isAvailable: _isBiometricAvailable && !_isLoading,
                    ),

                    SizedBox(height: 6.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New astrologer? ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () {
                            Navigator.pushNamed(
                                context, '/registration-screen');
                          },
                          child: Text(
                            'Sign Up',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
