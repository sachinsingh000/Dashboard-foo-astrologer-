import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AvailabilityToggleWidget extends StatelessWidget {
  final bool isOnline;
  final Function(bool) onToggle;
  final String currentStatus;

  const AvailabilityToggleWidget({
    super.key,
    required this.isOnline,
    required this.onToggle,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getStatusColor(currentStatus).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: _getStatusIcon(currentStatus),
              color: _getStatusColor(currentStatus),
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability Status',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _getStatusText(currentStatus),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(currentStatus),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isOnline,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              onToggle(value);
            },
            activeColor: theme.colorScheme.tertiary,
            activeTrackColor: theme.colorScheme.tertiary.withValues(alpha: 0.3),
            inactiveThumbColor: theme.colorScheme.onSurfaceVariant,
            inactiveTrackColor:
                theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return 'radio_button_checked';
      case 'busy':
        return 'do_not_disturb';
      case 'offline':
        return 'radio_button_unchecked';
      default:
        return 'help';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return const Color(0xFF4CAF50);
      case 'busy':
        return const Color(0xFFFF9800);
      case 'offline':
        return const Color(0xFF757575);
      default:
        return const Color(0xFF757575);
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return 'Online - Accepting Requests';
      case 'busy':
        return 'Busy - In Consultation';
      case 'offline':
        return 'Offline - Not Accepting';
      default:
        return 'Unknown Status';
    }
  }
}
