import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Gradient background widget for splash screen with system UI overlay
class GradientBackgroundWidget extends StatelessWidget {
  /// Child widget to display over the gradient
  final Widget child;

  /// Whether to hide status bar on Android
  final bool hideStatusBar;

  /// Custom gradient colors (optional)
  final List<Color>? gradientColors;

  const GradientBackgroundWidget({
    super.key,
    required this.child,
    this.hideStatusBar = true,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    _setSystemUIOverlayStyle();

    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ??
              [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.9),
                AppTheme.lightTheme.colorScheme.secondary,
              ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    if (hideStatusBar) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom],
      );
    }
  }
}
