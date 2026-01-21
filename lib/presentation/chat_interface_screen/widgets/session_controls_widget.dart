import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SessionControlsWidget extends StatelessWidget {
  final Duration sessionDuration;
  final double currentEarnings;

  final bool isSessionActive;
  final bool isSessionPaused;

  final VoidCallback? onPauseResume;
  final VoidCallback? onEndSession;

  final bool isReadOnly;

  const SessionControlsWidget({
    super.key,
    required this.sessionDuration,
    required this.currentEarnings,
    this.isSessionActive = true,
    this.isSessionPaused = false,
    this.onPauseResume,
    this.onEndSession,
    this.isReadOnly = false,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSessionInfo(
                  context: context,
                  icon: 'schedule',
                  label: 'Session Time',
                  value: _formatDuration(sessionDuration),
                  color: isSessionPaused
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildSessionInfo(
                  context: context,
                  icon: 'account_balance_wallet',
                  label: 'Earnings',
                  value: '\$${currentEarnings.toStringAsFixed(2)}',
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Column(
            children: [
                      if (!isReadOnly)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isSessionActive ? onPauseResume : null,
                        icon: CustomIconWidget(
                          iconName: isSessionPaused ? 'play_arrow' : 'pause',
                          color: isSessionActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                        label: Text(
                          isSessionPaused ? 'Resume' : 'Pause',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: isSessionActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isSessionActive ? onEndSession : null,
                        icon: CustomIconWidget(
                          iconName: 'call_end',
                          color: theme.colorScheme.onError,
                          size: 5.w,
                        ),
                        label: const Text('End Session'),
                      ),
                    ),
                  ],
                ),

              // other widgets below
            ],
          ),
          if (isSessionPaused) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'pause_circle',
                    color: theme.colorScheme.error,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Session Paused',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.error,
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

  Widget _buildSessionInfo({
    required BuildContext context,
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: color,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showEndSessionDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: theme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'End Session',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to end this consultation session?',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Session Duration:',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        _formatDuration(sessionDuration),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Earnings:',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '\$${currentEarnings.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onEndSession?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: Text(
              'End Session',
              style: theme.textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
