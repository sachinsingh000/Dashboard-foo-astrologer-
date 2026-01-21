import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClientInfoHeaderWidget extends StatelessWidget {
    final String clientName;
    final String consultationType;
    final String sessionDate;
    final String sessionDuration;
    final String clientAvatar;

    const ClientInfoHeaderWidget({
        super.key,
        required this.clientName,
        required this.consultationType,
        required this.sessionDate,
        required this.sessionDuration,
        required this.clientAvatar,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                    bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                    ),
                ),
            ),
            child: Row(
                children: [
                    Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                                width: 2,
                            ),
                        ),
                        child: ClipOval(
                            child: CustomImageWidget(
                                imageUrl: clientAvatar,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.cover,
                                semanticLabel:
                                "Profile photo of $clientName for consultation report",
                            ),
                        ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    clientName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface,
                                    ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                    children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w, vertical: 0.5.h),
                                            decoration: BoxDecoration(
                                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                                consultationType,
                                                style: theme.textTheme.labelSmall?.copyWith(
                                                    color: theme.colorScheme.primary,
                                                    fontWeight: FontWeight.w500,
                                                ),
                                            ),
                                        ),
                                        SizedBox(width: 2.w),
                                        CustomIconWidget(
                                            iconName: 'access_time',
                                            color: theme.colorScheme.onSurfaceVariant,
                                            size: 14,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                            sessionDuration,
                                            style: theme.textTheme.labelSmall?.copyWith(
                                                color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'calendar_today',
                                            color: theme.colorScheme.onSurfaceVariant,
                                            size: 14,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                            sessionDate,
                                            style: theme.textTheme.labelSmall?.copyWith(
                                                color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                            color: AppTheme.getSuccessColor(context).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: AppTheme.getSuccessColor(context),
                                    size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                    'Completed',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                        color: AppTheme.getSuccessColor(context),
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}
