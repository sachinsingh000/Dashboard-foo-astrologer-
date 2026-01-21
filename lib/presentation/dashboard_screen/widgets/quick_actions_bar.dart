import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsBar extends StatelessWidget {
    final VoidCallback onUpdateAvailability;
    final VoidCallback onViewRequests;
    final VoidCallback onAccessWallet;
    final VoidCallback onCreateReport;

    const QuickActionsBar({
        super.key,
        required this.onUpdateAvailability,
        required this.onViewRequests,
        required this.onAccessWallet,
        required this.onCreateReport,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                boxShadow: [
                    BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Quick Actions',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                        ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                        children: [
                            Expanded(
                                child: _buildActionButton(
                                    context,
                                    'Update Status',
                                    'toggle_on',
                                    theme.colorScheme.primary,
                                    onUpdateAvailability,
                                ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                                child: _buildActionButton(
                                    context,
                                    'View Requests',
                                    'notifications',
                                    AppTheme.getWarningColor(context),
                                    onViewRequests,
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: 2.w),
                    Row(
                        children: [
                            Expanded(
                                child: _buildActionButton(
                                    context,
                                    'Wallet',
                                    'account_balance_wallet',
                                    AppTheme.getSuccessColor(context),
                                    onAccessWallet,
                                ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                                child: _buildActionButton(
                                    context,
                                    'New Report',
                                    'description',
                                    theme.colorScheme.secondary,
                                    onCreateReport,
                                ),
                            ),
                        ],
                    ),
                ],
            ),
        );
    }

    Widget _buildActionButton(
        BuildContext context,
        String label,
        String iconName,
        Color color,
        VoidCallback onTap,
        ) {
        final theme = Theme.of(context);

        return GestureDetector(
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                    ),
                ),
                child: Column(
                    children: [
                        Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                                iconName: iconName,
                                color: theme.colorScheme.onPrimary,
                                size: 20,
                            ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                            label,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        ),
                    ],
                ),
            ),
        );
    }
}
