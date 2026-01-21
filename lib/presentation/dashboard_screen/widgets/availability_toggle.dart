import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum AvailabilityStatus { online, offline, busy }

class AvailabilityToggle extends StatelessWidget {
    final AvailabilityStatus currentStatus;
    final ValueChanged<AvailabilityStatus> onStatusChanged;

    const AvailabilityToggle({
        super.key,
        required this.currentStatus,
        required this.onStatusChanged,
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
                    Row(
                        children: [
                            CustomIconWidget(
                                iconName: 'circle',
                                color: _getStatusColor(context),
                                size: 12,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                                'Availability Status',
                                style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                        children: AvailabilityStatus.values.map((status) {
                            final isSelected = status == currentStatus;
                            return Expanded(
                                child: GestureDetector(
                                    onTap: () => onStatusChanged(status),
                                    child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: EdgeInsets.only(
                                            right:
                                            status != AvailabilityStatus.values.last ? 2.w : 0),
                                        padding:
                                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? _getStatusColor(context).withValues(alpha: 0.1)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                                color: isSelected
                                                    ? _getStatusColor(context)
                                                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                                                width: isSelected ? 2 : 1,
                                            ),
                                        ),
                                        child: Column(
                                            children: [
                                                Container(
                                                    width: 8.w,
                                                    height: 8.w,
                                                    decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? _getStatusColor(context)
                                                            : theme.colorScheme.outline
                                                            .withValues(alpha: 0.3),
                                                        shape: BoxShape.circle,
                                                    ),
                                                    child: isSelected
                                                        ? CustomIconWidget(
                                                        iconName: _getStatusIcon(status),
                                                        color: theme.colorScheme.onPrimary,
                                                        size: 16,
                                                    )
                                                        : null,
                                                ),
                                                SizedBox(height: 1.h),
                                                Text(
                                                    _getStatusText(status),
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                        color: isSelected
                                                            ? _getStatusColor(context)
                                                            : theme.colorScheme.onSurfaceVariant,
                                                        fontWeight:
                                                        isSelected ? FontWeight.w600 : FontWeight.w400,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                            );
                        }).toList(),
                    ),
                    if (currentStatus == AvailabilityStatus.online) ...[
                        SizedBox(height: 2.h),
                        Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                                color: AppTheme.getSuccessColor(context).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                                children: [
                                    CustomIconWidget(
                                        iconName: 'info',
                                        color: AppTheme.getSuccessColor(context),
                                        size: 16,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                        child: Text(
                                            'You\'re visible to clients and can receive consultation requests',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                                color: AppTheme.getSuccessColor(context),
                                            ),
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

    Color _getStatusColor(BuildContext context) {
        switch (currentStatus) {
            case AvailabilityStatus.online:
                return AppTheme.getSuccessColor(context);
            case AvailabilityStatus.busy:
                return AppTheme.getWarningColor(context);
            case AvailabilityStatus.offline:
                return Theme.of(context).colorScheme.outline;
        }
    }

    String _getStatusIcon(AvailabilityStatus status) {
        switch (status) {
            case AvailabilityStatus.online:
                return 'check';
            case AvailabilityStatus.busy:
                return 'schedule';
            case AvailabilityStatus.offline:
                return 'close';
        }
    }

    String _getStatusText(AvailabilityStatus status) {
        switch (status) {
            case AvailabilityStatus.online:
                return 'Online';
            case AvailabilityStatus.busy:
                return 'Busy';
            case AvailabilityStatus.offline:
                return 'Offline';
        }
    }
}
