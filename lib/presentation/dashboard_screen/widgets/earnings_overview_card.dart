import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EarningsOverviewCard extends StatelessWidget {
    final double todayEarnings;
    final int consultationCount;
    final String averageSessionDuration;
    final VoidCallback onTap;

    const EarningsOverviewCard({
        super.key,
        required this.todayEarnings,
        required this.consultationCount,
        required this.averageSessionDuration,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return GestureDetector(
            onTap: onTap,
            onLongPress: () => _showDetailedBreakdown(context),
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.8),
                        ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                        BoxShadow(
                            color: theme.shadowColor.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                        ),
                    ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    'Today\'s Earnings',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                                CustomIconWidget(
                                    iconName: 'trending_up',
                                    color: theme.colorScheme.onPrimary,
                                    size: 20,
                                ),
                            ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                            '\$${todayEarnings.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 32.sp,
                            ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                            children: [
                                Expanded(
                                    child: _buildMetricItem(
                                        context,
                                        'Consultations',
                                        consultationCount.toString(),
                                        'calendar_today',
                                    ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                    child: _buildMetricItem(
                                        context,
                                        'Avg Duration',
                                        averageSessionDuration,
                                        'schedule',
                                    ),
                                ),
                            ],
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildMetricItem(
        BuildContext context,
        String label,
        String value,
        String iconName,
        ) {
        final theme = Theme.of(context);

        return Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        children: [
                            CustomIconWidget(
                                iconName: iconName,
                                color: theme.colorScheme.onPrimary,
                                size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                                child: Text(
                                    label,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                        value,
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                        ),
                    ),
                ],
            ),
        );
    }

    void _showDetailedBreakdown(BuildContext context) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
                height: 50.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.all(4.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Center(
                            child: Container(
                                width: 12.w,
                                height: 0.5.h,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.outline,
                                    borderRadius: BorderRadius.circular(2),
                                ),
                            ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                            'Earnings Breakdown',
                            style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 2.h),
                        Expanded(
                            child: ListView(
                                children: [
                                    _buildBreakdownItem(context, 'Chat Consultations',
                                        '\$${(todayEarnings * 0.4).toStringAsFixed(2)}', 'chat'),
                                    _buildBreakdownItem(context, 'Audio Calls',
                                        '\$${(todayEarnings * 0.35).toStringAsFixed(2)}', 'call'),
                                    _buildBreakdownItem(
                                        context,
                                        'Video Calls',
                                        '\$${(todayEarnings * 0.2).toStringAsFixed(2)}',
                                        'videocam'),
                                    _buildBreakdownItem(
                                        context,
                                        'Reports',
                                        '\$${(todayEarnings * 0.05).toStringAsFixed(2)}',
                                        'description'),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildBreakdownItem(
        BuildContext context, String title, String amount, String iconName) {
        final theme = Theme.of(context);

        return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border:
                Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Row(
                children: [
                    Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                            iconName: iconName,
                            color: theme.colorScheme.primary,
                            size: 20,
                        ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                        child: Text(
                            title,
                            style: theme.textTheme.bodyLarge,
                        ),
                    ),
                    Text(
                        amount,
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                        ),
                    ),
                ],
            ),
        );
    }
}
