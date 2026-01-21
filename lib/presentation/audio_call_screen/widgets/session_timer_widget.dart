import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionTimerWidget extends StatelessWidget {
    final Duration elapsedTime;
    final double earningsPerMinute;
    final double totalEarnings;
    final bool isPaused;
    final VoidCallback? onPauseToggle;

    const SessionTimerWidget({
        super.key,
        required this.elapsedTime,
        required this.earningsPerMinute,
        required this.totalEarnings,
        this.isPaused = false,
        this.onPauseToggle,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                    BoxShadow(
                        color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                    ),
                ],
            ),
            child: Column(
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(
                                'Session Time',
                                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                            ),
                            if (onPauseToggle != null)
                                GestureDetector(
                                    onTap: onPauseToggle,
                                    child: Container(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                        decoration: BoxDecoration(
                                            color: isPaused
                                                ? AppTheme.getWarningColor(context)
                                                .withValues(alpha: 0.1)
                                                : AppTheme.getSuccessColor(context)
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                CustomIconWidget(
                                                    iconName: isPaused ? 'play_arrow' : 'pause',
                                                    size: 4.w,
                                                    color: isPaused
                                                        ? AppTheme.getWarningColor(context)
                                                        : AppTheme.getSuccessColor(context),
                                                ),
                                                SizedBox(width: 1.w),
                                                Text(
                                                    isPaused ? 'Resume' : 'Pause',
                                                    style: AppTheme.lightTheme.textTheme.labelSmall
                                                        ?.copyWith(
                                                        color: isPaused
                                                            ? AppTheme.getWarningColor(context)
                                                            : AppTheme.getSuccessColor(context),
                                                        fontWeight: FontWeight.w500,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                        ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                        _formatDuration(elapsedTime),
                        style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                            color: isPaused
                                ? AppTheme.getWarningColor(context)
                                : AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                        ),
                    ),
                    SizedBox(height: 2.h),
                    Divider(
                        color:
                        AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                        thickness: 1,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        'Rate',
                                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                        ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                        '\$${earningsPerMinute.toStringAsFixed(2)}/min',
                                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                            color: AppTheme.lightTheme.colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                ],
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                    Text(
                                        'Total Earnings',
                                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                        ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                        '\$${totalEarnings.toStringAsFixed(2)}',
                                        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                                            color: AppTheme.getSuccessColor(context),
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                ],
                            ),
                        ],
                    ),
                    if (isPaused) ...[
                        SizedBox(height: 2.h),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            decoration: BoxDecoration(
                                color: AppTheme.getWarningColor(context).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    CustomIconWidget(
                                        iconName: 'pause_circle',
                                        size: 4.w,
                                        color: AppTheme.getWarningColor(context),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                        'Session Paused',
                                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                            color: AppTheme.getWarningColor(context),
                                            fontWeight: FontWeight.w500,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ],
            ),
        );
    }

    String _formatDuration(Duration duration) {
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        String hours = twoDigits(duration.inHours);
        String minutes = twoDigits(duration.inMinutes.remainder(60));
        String seconds = twoDigits(duration.inSeconds.remainder(60));
        return '$hours:$minutes:$seconds';
    }
}
