import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MetricsCards extends StatelessWidget {
    final int pendingRequests;
    final int activeChatSessions;
    final double walletBalance;
    final int todayScheduleCount;

    const MetricsCards({
        super.key,
        required this.pendingRequests,
        required this.activeChatSessions,
        required this.walletBalance,
        required this.todayScheduleCount,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            height: 20.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                    _buildMetricCard(
                        context,
                        'Pending Requests',
                        pendingRequests.toString(),
                        'notifications',
                        AppTheme.getWarningColor(context),
                            () => Navigator.pushNamed(context, '/consultation-requests-screen'),
                    ),
                    _buildMetricCard(
                        context,
                        'Active Chats',
                        activeChatSessions.toString(),
                        'chat',
                        AppTheme.getSuccessColor(context),
                            () => Navigator.pushNamed(context, '/chat-interface-screen'),
                    ),
                    _buildMetricCard(
                        context,
                        'Wallet Balance',
                        '\$${walletBalance.toStringAsFixed(2)}',
                        'account_balance_wallet',
                        Theme.of(context).colorScheme.primary,
                            () => Navigator.pushNamed(context, '/wallet-and-earnings-screen'),
                    ),
                    _buildMetricCard(
                        context,
                        'Today\'s Schedule',
                        todayScheduleCount.toString(),
                        'today',
                        Theme.of(context).colorScheme.secondary,
                            () => Navigator.pushNamed(context, '/consultation-requests-screen'),
                    ),
                ],
            ),
        );
    }

    Widget _buildMetricCard(
        BuildContext context,
        String title,
        String value,
        String iconName,
        Color accentColor,
        VoidCallback onTap,
        ) {
        final theme = Theme.of(context);

        return GestureDetector(
            onTap: onTap,
            child: Container(
                width: 40.w,
                margin: EdgeInsets.only(right: 3.w),
                padding: EdgeInsets.all(4.w),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                        color: accentColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomIconWidget(
                                        iconName: iconName,
                                        color: accentColor,
                                        size: 20,
                                    ),
                                ),
                                if (title == 'Pending Requests' && pendingRequests > 0)
                                    Container(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                            color: theme.colorScheme.error,
                                            borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                            'New',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                                color: theme.colorScheme.onError,
                                                fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                    ),
                            ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                            value,
                            style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                            ),
                        ),
                        SizedBox(height: 1.h),
                        Expanded(
                            child: Text(
                                title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
