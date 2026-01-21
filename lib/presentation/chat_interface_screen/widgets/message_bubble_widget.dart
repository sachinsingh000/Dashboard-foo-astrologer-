import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
    final Map<String, dynamic> message;
    final bool isAstrologer;

    const MessageBubbleWidget({
        super.key,
        required this.message,
        required this.isAstrologer,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final messageTime = message['timestamp'] as DateTime;
        final isRead = message['isRead'] as bool? ?? false;

        return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            child: Row(
                mainAxisAlignment:
                isAstrologer ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                    if (!isAstrologer) ...[
                        CircleAvatar(
                            radius: 2.5.w,
                            backgroundColor: theme.colorScheme.primary,
                            child: CustomIconWidget(
                                iconName: 'person',
                                color: theme.colorScheme.onPrimary,
                                size: 3.w,
                            ),
                        ),
                        SizedBox(width: 2.w),
                    ],
                    Flexible(
                        child: Container(
                            constraints: BoxConstraints(maxWidth: 70.w),
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                                color: isAstrologer
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surface,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.w),
                                    topRight: Radius.circular(4.w),
                                    bottomLeft: isAstrologer
                                        ? Radius.circular(4.w)
                                        : Radius.circular(1.w),
                                    bottomRight: isAstrologer
                                        ? Radius.circular(1.w)
                                        : Radius.circular(4.w),
                                ),
                                border: !isAstrologer
                                    ? Border.all(
                                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                                    width: 1,
                                )
                                    : null,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    if (message['type'] == 'file') ...[
                                        _buildFileMessage(context),
                                    ] else if (message['type'] == 'image') ...[
                                        _buildImageMessage(context),
                                    ] else ...[
                                        Text(
                                            message['content'] as String,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                                color: isAstrologer
                                                    ? theme.colorScheme.onPrimary
                                                    : theme.colorScheme.onSurface,
                                            ),
                                        ),
                                    ],
                                    SizedBox(height: 0.5.h),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Text(
                                                '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}',
                                                style: theme.textTheme.labelSmall?.copyWith(
                                                    color: isAstrologer
                                                        ? theme.colorScheme.onPrimary
                                                        .withValues(alpha: 0.7)
                                                        : theme.colorScheme.onSurfaceVariant,
                                                ),
                                            ),
                                            if (isAstrologer) ...[
                                                SizedBox(width: 1.w),
                                                CustomIconWidget(
                                                    iconName: isRead ? 'done_all' : 'done',
                                                    color: isRead
                                                        ? theme.colorScheme.tertiary
                                                        : theme.colorScheme.onPrimary
                                                        .withValues(alpha: 0.7),
                                                    size: 3.w,
                                                ),
                                            ],
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ),
                    if (isAstrologer) ...[
                        SizedBox(width: 2.w),
                        CircleAvatar(
                            radius: 2.5.w,
                            backgroundColor: theme.colorScheme.secondary,
                            child: CustomIconWidget(
                                iconName: 'auto_awesome',
                                color: theme.colorScheme.onSecondary,
                                size: 3.w,
                            ),
                        ),
                    ],
                ],
            ),
        );
    }

    Widget _buildFileMessage(BuildContext context) {
        final theme = Theme.of(context);
        final fileName = message['fileName'] as String? ?? 'Document';
        final fileSize = message['fileSize'] as String? ?? '';

        return Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
                color: isAstrologer
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.1)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    CustomIconWidget(
                        iconName: 'description',
                        color: isAstrologer
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.primary,
                        size: 6.w,
                    ),
                    SizedBox(width: 2.w),
                    Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    fileName,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: isAstrologer
                                            ? theme.colorScheme.onPrimary
                                            : theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                ),
                                if (fileSize.isNotEmpty) ...[
                                    Text(
                                        fileSize,
                                        style: theme.textTheme.labelSmall?.copyWith(
                                            color: isAstrologer
                                                ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                                                : theme.colorScheme.onSurfaceVariant,
                                        ),
                                    ),
                                ],
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildImageMessage(BuildContext context) {
        final imageUrl = message['imageUrl'] as String;
        final semanticLabel = message['semanticLabel'] as String? ?? 'Shared image';

        return ClipRRect(
            borderRadius: BorderRadius.circular(2.w),
            child: CustomImageWidget(
                imageUrl: imageUrl,
                width: 50.w,
                height: 30.h,
                fit: BoxFit.cover,
                semanticLabel: semanticLabel,
            ),
        );
    }
}
