import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/custom_image_widget.dart';

class ChatListItemWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const ChatListItemWidget({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        margin: EdgeInsets.only(bottom: 3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 6.w,
              backgroundColor: Colors.grey.shade200,
              child: CustomImageWidget(
                imageUrl: data["user"]["avatar"] ??
                    "https://i.imgur.com/BoN9kdC.png",
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 4.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["user"]["name"] ?? "Unknown User",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 0.5.h),

                  Text(
                    data["lastMessage"] ?? "No messages yet",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 0.5.h),

                  Text(
                    data["lastUpdated"],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20.sp,
            )
          ],
        ),
      ),
    );
  }
}
