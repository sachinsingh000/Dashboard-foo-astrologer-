import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TypingIndicatorWidget extends StatefulWidget {
    final bool isVisible;
    final String userName;

    const TypingIndicatorWidget({
        super.key,
        required this.isVisible,
        required this.userName,
    });

    @override
    State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _animation;

    @override
    void initState() {
        super.initState();
        _animationController = AnimationController(
            duration: const Duration(milliseconds: 1500),
            vsync: this,
        );
        _animation = Tween<double>(
            begin: 0.0,
            end: 1.0,
        ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
        ));

        if (widget.isVisible) {
            _animationController.repeat();
        }
    }

    @override
    void didUpdateWidget(TypingIndicatorWidget oldWidget) {
        super.didUpdateWidget(oldWidget);
        if (widget.isVisible != oldWidget.isVisible) {
            if (widget.isVisible) {
                _animationController.repeat();
            } else {
                _animationController.stop();
            }
        }
    }

    @override
    void dispose() {
        _animationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        if (!widget.isVisible) return const SizedBox.shrink();

        final theme = Theme.of(context);

        return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
                children: [
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
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(4.w),
                            border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                                width: 1,
                            ),
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                Text(
                                    '${widget.userName} is typing',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontStyle: FontStyle.italic,
                                    ),
                                ),
                                SizedBox(width: 2.w),
                                AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                        return Row(
                                            children: List.generate(3, (index) {
                                                final delay = index * 0.2;
                                                final animationValue =
                                                (_animation.value - delay).clamp(0.0, 1.0);
                                                final opacity = (animationValue * 2).clamp(0.0, 1.0);

                                                return Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                                                    child: Opacity(
                                                        opacity: opacity > 1.0 ? 2.0 - opacity : opacity,
                                                        child: Container(
                                                            width: 1.5.w,
                                                            height: 1.5.w,
                                                            decoration: BoxDecoration(
                                                                color: theme.colorScheme.primary,
                                                                shape: BoxShape.circle,
                                                            ),
                                                        ),
                                                    ),
                                                );
                                            }),
                                        );
                                    },
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}
