import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Video feed widget for displaying camera preview
/// Handles both client and astrologer video feeds
class VideoFeedWidget extends StatefulWidget {
  final CameraController? cameraController;
  final bool isMainFeed;
  final bool isVisible;
  final String? placeholderText;
  final String? placeholderImageUrl;
  final VoidCallback? onTap;

  const VideoFeedWidget({
    super.key,
    this.cameraController,
    required this.isMainFeed,
    this.isVisible = true,
    this.placeholderText,
    this.placeholderImageUrl,
    this.onTap,
  });

  @override
  State<VideoFeedWidget> createState() => _VideoFeedWidgetState();
}

class _VideoFeedWidgetState extends State<VideoFeedWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius:
              widget.isMainFeed ? BorderRadius.zero : BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius:
              widget.isMainFeed ? BorderRadius.zero : BorderRadius.circular(12),
          child: _buildVideoContent(context),
        ),
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    if (!widget.isVisible) {
      return _buildVideoOffPlaceholder(context);
    }

    if (widget.cameraController != null &&
        widget.cameraController!.value.isInitialized) {
      return _buildCameraPreview(context);
    }

    return _buildLoadingPlaceholder(context);
  }

  Widget _buildCameraPreview(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(widget.cameraController!),
        if (!widget.isMainFeed)
          Positioned(
            bottom: 2.w,
            right: 2.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'You',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.placeholderImageUrl != null)
            Container(
              width: widget.isMainFeed ? 20.w : 15.w,
              height: widget.isMainFeed ? 20.w : 15.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: widget.placeholderImageUrl!,
                  width: widget.isMainFeed ? 20.w : 15.w,
                  height: widget.isMainFeed ? 20.w : 15.w,
                  fit: BoxFit.cover,
                  semanticLabel:
                      "Profile photo placeholder for video call participant",
                ),
              ),
            )
          else
            Container(
              width: widget.isMainFeed ? 20.w : 15.w,
              height: widget.isMainFeed ? 20.w : 15.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: Colors.white,
                size: widget.isMainFeed ? 24.sp : 18.sp,
              ),
            ),
          SizedBox(height: 2.h),
          SizedBox(
            width: 6.w,
            height: 6.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            widget.placeholderText ?? 'Connecting...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: widget.isMainFeed ? 14.sp : 12.sp,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoOffPlaceholder(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: widget.isMainFeed ? 20.w : 15.w,
            height: widget.isMainFeed ? 20.w : 15.w,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'videocam_off',
              color: Colors.white,
              size: widget.isMainFeed ? 24.sp : 18.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Camera Off',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: widget.isMainFeed ? 14.sp : 12.sp,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
