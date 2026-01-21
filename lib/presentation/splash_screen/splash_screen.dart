import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_connection_widget.dart';

/// Splash Screen for AstroPro Provider application
/// Handles app initialization, authentication check, and navigation logic
class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
    double _loadingProgress = 0.0;
    String _statusMessage = 'Initializing AstroPro...';
    bool _showRetryWidget = false;
    bool _isInitializing = true;

    // Mock initialization data
    final List<Map<String, dynamic>> _initializationSteps = [
        {'message': 'Checking authentication...', 'duration': 800},
        {'message': 'Loading astrologer profile...', 'duration': 600},
        {'message': 'Fetching consultation requests...', 'duration': 700},
        {'message': 'Preparing earnings data...', 'duration': 500},
        {'message': 'Finalizing setup...', 'duration': 400},
    ];

    @override
    void initState() {
        super.initState();
        _initializeApp();
    }

    /// Initialize the application with proper error handling
    Future<void> _initializeApp() async {
        try {
            // Check network connectivity
            final connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult.contains(ConnectivityResult.none)) {
                _showNetworkError();
                return;
            }

            // Start initialization process
            await _performInitializationSteps();

            // Check authentication and navigate
            await _checkAuthenticationAndNavigate();
        } catch (e) {
            _showNetworkError();
        }
    }

    /// Perform step-by-step initialization with progress updates
    Future<void> _performInitializationSteps() async {
        for (int i = 0; i < _initializationSteps.length; i++) {
            if (!mounted) return;

            final step = _initializationSteps[i];

            setState(() {
                _statusMessage = step['message'] as String;
                _loadingProgress = (i + 1) / _initializationSteps.length;
            });

            // Simulate initialization work
            await Future.delayed(Duration(milliseconds: step['duration'] as int));
        }
    }

    /// Check authentication status and navigate to appropriate screen
    Future<void> _checkAuthenticationAndNavigate() async {
        try {
            final prefs = await SharedPreferences.getInstance();

            // Check for authentication token
            final authToken = prefs.getString('auth_token');
            final isKycVerified = prefs.getBool('kyc_verified') ?? false;
            final hasCompletedProfile = prefs.getBool('profile_completed') ?? false;

            // Handle deep link for consultation invitations
            final pendingDeepLink = prefs.getString('pending_deep_link');

            await Future.delayed(const Duration(milliseconds: 500));

            if (!mounted) return;

            // Navigation logic based on authentication status
            if (authToken != null && authToken.isNotEmpty) {
                if (!isKycVerified) {
                    Navigator.pushReplacementNamed(context, '/kyc-verification-screen');
                } else if (!hasCompletedProfile) {
                    Navigator.pushReplacementNamed(context, '/profile-management-screen');
                } else {
                    // Handle deep link if exists
                    if (pendingDeepLink != null) {
                        await prefs.remove('pending_deep_link');
                        _handleDeepLink(pendingDeepLink);
                    } else {
                        Navigator.pushReplacementNamed(context, '/dashboard-screen');
                    }
                }
            } else {
                // Check if user has previously registered
                final hasRegistered = prefs.getBool('has_registered') ?? false;
                if (hasRegistered) {
                    Navigator.pushReplacementNamed(context, '/login-screen');
                } else {
                    Navigator.pushReplacementNamed(context, '/registration-screen');
                }
            }
        } catch (e) {
            // Fallback to registration screen on error
            if (mounted) {
                Navigator.pushReplacementNamed(context, '/registration-screen');
            }
        }
    }

    /// Handle deep link navigation after authentication
    void _handleDeepLink(String deepLink) {
        // Parse deep link and navigate accordingly
        if (deepLink.contains('consultation')) {
            Navigator.pushReplacementNamed(context, '/consultation-requests-screen');
        } else if (deepLink.contains('chat')) {
            Navigator.pushReplacementNamed(context, '/chat-interface-screen');
        } else {
            Navigator.pushReplacementNamed(context, '/dashboard-screen');
        }
    }

    /// Show network error with retry option
    void _showNetworkError() {
        if (mounted) {
            setState(() {
                _showRetryWidget = true;
                _isInitializing = false;
            });

            // Auto-retry after 5 seconds
            Future.delayed(const Duration(seconds: 5), () {
                if (mounted && _showRetryWidget) {
                    _retryInitialization();
                }
            });
        }
    }

    /// Retry initialization process
    void _retryInitialization() {
        setState(() {
            _showRetryWidget = false;
            _isInitializing = true;
            _loadingProgress = 0.0;
            _statusMessage = 'Retrying connection...';
        });

        _initializeApp();
    }

    /// Handle logo animation completion
    void _onLogoAnimationComplete() {
        // Logo animation completed, initialization should be in progress
    }

    @override
    void dispose() {
        // Reset system UI overlay style
        SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
        );
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: GradientBackgroundWidget(
                hideStatusBar: true,
                child: _buildSplashContent(),
            ),
        );
    }

    /// Build splash screen content based on current state
    Widget _buildSplashContent() {
        if (_showRetryWidget) {
            return RetryConnectionWidget(
                onRetry: _retryInitialization,
                errorMessage:
                'Unable to connect to AstroPro services. Please check your internet connection and try again.',
            );
        }

        return Column(
            children: [
                Expanded(
                    flex: 3,
                    child: AnimatedLogoWidget(
                        animationDuration: const Duration(milliseconds: 2500),
                        onAnimationComplete: _onLogoAnimationComplete,
                    ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            if (_isInitializing) ...[
                                LoadingIndicatorWidget(
                                    progress: _loadingProgress,
                                    statusMessage: _statusMessage,
                                    showProgress: true,
                                ),
                                SizedBox(height: 4.h),
                            ],
                            Text(
                                'Professional Astrology Services',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 11.sp,
                                    letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                                'v1.0.0',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 10.sp,
                                ),
                            ),
                        ],
                    ),
                ),
            ],
        );
    }
}
