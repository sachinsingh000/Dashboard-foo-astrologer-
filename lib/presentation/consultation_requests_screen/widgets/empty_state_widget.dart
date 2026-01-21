import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
    final String filterType;
    final bool isOnline;
    final VoidCallback onGoOnline;

    const EmptyStateWidget({
        super.key,
        required this.filterType,
        required this.isOnline,
        required this.onGoOnline,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Center(
            child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                                color:
                                theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                                iconName: _getEmptyStateIcon(),
                                color: theme.colorScheme.primary,
                                size: 15.w,
                            ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                            _getEmptyStateTitle(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                            _getEmptyStateMessage(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                        ),
                        if (!isOnline) ...[
                            SizedBox(height: 4.h),
                            ElevatedButton(
                                onPressed: onGoOnline,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.tertiary,
                                    foregroundColor: theme.colorScheme.onTertiary,
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                    ),
                                ),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'radio_button_checked',
                                            color: theme.colorScheme.onTertiary,
                                            size: 20,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                            'Go Online',
                                            style: theme.textTheme.titleSmall?.copyWith(
                                                color: theme.colorScheme.onTertiary,
                                                fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ],
                        if (isOnline) ...[
                            SizedBox(height: 4.h),
                            Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiaryContainer
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'lightbulb',
                                            color: theme.colorScheme.tertiary,
                                            size: 20,
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                            child: Text(
                                                'Tip: Update your profile and set competitive rates to attract more clients!',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                    color: theme.colorScheme.tertiary,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    ],
                ),
            ),
        );
    }

    String _getEmptyStateIcon() {
        if (!isOnline) {
            return 'wifi_off';
        }

        switch (filterType.toLowerCase()) {
            case 'chat':
                return 'chat';
            case 'audio':
                return 'call';
            case 'video':
                return 'videocam';
            case 'report':
                return 'description';
            default:
                return 'inbox';
        }
    }

    String _getEmptyStateTitle() {
        if (!isOnline) {
            return 'You\'re Currently Offline';
        }

        switch (filterType.toLowerCase()) {
            case 'chat':
                return 'No Chat Requests';
            case 'audio':
                return 'No Audio Call Requests';
            case 'video':
                return 'No Video Call Requests';
            case 'report':
                return 'No Report Requests';
            default:
                return 'No Consultation Requests';
        }
    }

    String _getEmptyStateMessage() {
        if (!isOnline) {
            return 'Go online to start receiving consultation requests from clients. Your expertise is waiting to help someone today!';
        }

        switch (filterType.toLowerCase()) {
            case 'chat':
                return 'No chat consultation requests at the moment. Stay online to receive new requests from clients seeking your guidance.';
            case 'audio':
                return 'No audio call requests right now. Keep your availability status updated to attract clients who prefer voice consultations.';
            case 'video':
                return 'No video call requests currently. Make sure your profile showcases your expertise to attract video consultation clients.';
            case 'report':
                return 'No report-based consultation requests. Clients may request detailed written reports based on their birth charts.';
            default:
                return 'No consultation requests at the moment. Stay online and keep your profile updated to attract more clients.';
        }
    }
}
