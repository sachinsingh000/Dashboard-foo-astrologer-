import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Retry connection widget for network timeout scenarios
class RetryConnectionWidget extends StatelessWidget {
  /// Callback when retry button is pressed
  final VoidCallback onRetry;

  /// Error message to display
  final String errorMessage;

  /// Whether to show the retry button
  final bool showRetryButton;

  const RetryConnectionWidget({
    super.key,
    required this.onRetry,
    this.errorMessage =
        'Connection timeout. Please check your internet connection.',
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'wifi_off',
                color: Colors.white.withValues(alpha: 0.8),
                size: 8.w,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Connection Issue',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12.sp,
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
          if (showRetryButton) ...[
            SizedBox(height: 4.h),
            SizedBox(
              width: 40.w,
              height: 6.h,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.lightTheme.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.h),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
