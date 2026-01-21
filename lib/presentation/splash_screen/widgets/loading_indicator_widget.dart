import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Custom loading indicator widget for splash screen initialization
class LoadingIndicatorWidget extends StatefulWidget {
  /// Current loading progress (0.0 to 1.0)
  final double progress;

  /// Loading status message
  final String statusMessage;

  /// Whether to show the progress bar
  final bool showProgress;

  const LoadingIndicatorWidget({
    super.key,
    this.progress = 0.0,
    this.statusMessage = 'Initializing...',
    this.showProgress = true,
  });

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showProgress) ...[
          Container(
            width: 60.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.h),
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.h),
              child: LinearProgressIndicator(
                value: widget.progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
                minHeight: 0.5.h,
              ),
            ),
          ),
          SizedBox(height: 3.h),
        ],
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.5.w,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    widget.statusMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
