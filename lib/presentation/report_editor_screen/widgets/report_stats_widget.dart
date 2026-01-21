import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReportStatsWidget extends StatelessWidget {
    final int wordCount;
    final int estimatedReadingTime;
    final DateTime? lastSaved;
    final bool isAutoSaving;

    const ReportStatsWidget({
        super.key,
        required this.wordCount,
        required this.estimatedReadingTime,
        this.lastSaved,
        this.isAutoSaving = false,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                    top: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                    ),
                ),
            ),
            child: Row(
                children: [
                    _buildStatItem(
                        context: context,
                        icon: 'text_fields',
                        label: 'Words',
                        value: wordCount.toString(),
                    ),
                    SizedBox(width: 4.w),
                    _buildStatItem(
                        context: context,
                        icon: 'schedule',
                        label: 'Read time',
                        value: '${estimatedReadingTime}m',
                    ),
                    const Spacer(),
                    _buildSaveStatus(context),
                ],
            ),
        );
    }

    Widget _buildStatItem({
        required BuildContext context,
        required String icon,
        required String label,
        required String value,
    }) {
        final theme = Theme.of(context);

        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                CustomIconWidget(
                    iconName: icon,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 16,
                ),
                SizedBox(width: 1.w),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            value,
                            style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                            ),
                        ),
                        Text(
                            label,
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                            ),
                        ),
                    ],
                ),
            ],
        );
    }

    Widget _buildSaveStatus(BuildContext context) {
        final theme = Theme.of(context);

        if (isAutoSaving) {
            return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                            ),
                        ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                        'Saving...',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                        ),
                    ),
                ],
            );
        }

        if (lastSaved != null) {
            final now = DateTime.now();
            final difference = now.difference(lastSaved!);
            String timeAgo;

            if (difference.inMinutes < 1) {
                timeAgo = 'Just now';
            } else if (difference.inMinutes < 60) {
                timeAgo = '${difference.inMinutes}m ago';
            } else if (difference.inHours < 24) {
                timeAgo = '${difference.inHours}h ago';
            } else {
                timeAgo = '${difference.inDays}d ago';
            }

            return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    CustomIconWidget(
                        iconName: 'cloud_done',
                        color: AppTheme.getSuccessColor(context),
                        size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                        'Saved $timeAgo',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.getSuccessColor(context),
                        ),
                    ),
                ],
            );
        }

        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                CustomIconWidget(
                    iconName: 'cloud_off',
                    color: AppTheme.getWarningColor(context),
                    size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                    'Not saved',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.getWarningColor(context),
                    ),
                ),
            ],
        );
    }
}
