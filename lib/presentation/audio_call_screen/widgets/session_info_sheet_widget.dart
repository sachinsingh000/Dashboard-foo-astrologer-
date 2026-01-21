import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionInfoSheetWidget extends StatelessWidget {
    final String consultationTopic;
    final Duration agreedDuration;
    final double ratePerMinute;
    final String sessionId;
    final DateTime startTime;

    const SessionInfoSheetWidget({
        super.key,
        required this.consultationTopic,
        required this.agreedDuration,
        required this.ratePerMinute,
        required this.sessionId,
        required this.startTime,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                ),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Container(
                        width: 12.w,
                        height: 0.5.h,
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(6.w),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    'Session Details',
                                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                                SizedBox(height: 3.h),
                                _buildInfoRow(
                                    context,
                                    'Topic',
                                    consultationTopic,
                                    'topic',
                                ),
                                SizedBox(height: 2.h),
                                _buildInfoRow(
                                    context,
                                    'Agreed Duration',
                                    _formatDuration(agreedDuration),
                                    'schedule',
                                ),
                                SizedBox(height: 2.h),
                                _buildInfoRow(
                                    context,
                                    'Rate',
                                    '\$${ratePerMinute.toStringAsFixed(2)}/minute',
                                    'attach_money',
                                ),
                                SizedBox(height: 2.h),
                                _buildInfoRow(
                                    context,
                                    'Session ID',
                                    sessionId,
                                    'tag',
                                ),
                                SizedBox(height: 2.h),
                                _buildInfoRow(
                                    context,
                                    'Started At',
                                    _formatTime(startTime),
                                    'access_time',
                                ),
                                SizedBox(height: 3.h),
                                _buildConnectionQuality(context),
                                SizedBox(height: 3.h),
                                _buildActionButtons(context),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildInfoRow(
        BuildContext context, String label, String value, String iconName) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: CustomIconWidget(
                            iconName: iconName,
                            size: 5.w,
                            color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                        ),
                    ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                label,
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                                value,
                                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                ),
                            ),
                        ],
                    ),
                ),
            ],
        );
    }

    Widget _buildConnectionQuality(BuildContext context) {
        return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.getSuccessColor(context).withValues(alpha: 0.3),
                    width: 1,
                ),
            ),
            child: Row(
                children: [
                    CustomIconWidget(
                        iconName: 'signal_cellular_4_bar',
                        size: 5.w,
                        color: AppTheme.getSuccessColor(context),
                    ),
                    SizedBox(width: 3.w),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                'Connection Quality',
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                            ),
                            Text(
                                'Excellent',
                                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.getSuccessColor(context),
                                    fontWeight: FontWeight.w600,
                                ),
                            ),
                        ],
                    ),
                    const Spacer(),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                            color: AppTheme.getSuccessColor(context),
                            borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                            'HD Audio',
                            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildActionButtons(BuildContext context) {
        return Row(
            children: [
                Expanded(
                    child: OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/chat-interface-screen'),
                        icon: CustomIconWidget(
                            iconName: 'chat',
                            size: 4.w,
                            color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        label: Text(
                            'Open Chat',
                            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                        ),
                    ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                    child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/report-editor-screen'),
                        icon: CustomIconWidget(
                            iconName: 'description',
                            size: 4.w,
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                        label: Text(
                            'Create Report',
                            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                        ),
                    ),
                ),
            ],
        );
    }

    String _formatDuration(Duration duration) {
        int minutes = duration.inMinutes;
        return '$minutes minutes';
    }

    String _formatTime(DateTime time) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
}
