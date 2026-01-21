import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallControlsWidget extends StatefulWidget {
    final bool isMuted;
    final bool isSpeakerOn;
    final VoidCallback onMuteToggle;
    final VoidCallback onSpeakerToggle;
    final VoidCallback onEndCall;
    final VoidCallback onShowNotes;

    const CallControlsWidget({
        super.key,
        required this.isMuted,
        required this.isSpeakerOn,
        required this.onMuteToggle,
        required this.onSpeakerToggle,
        required this.onEndCall,
        required this.onShowNotes,
    });

    @override
    State<CallControlsWidget> createState() => _CallControlsWidgetState();
}

class _CallControlsWidgetState extends State<CallControlsWidget>
    with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _scaleAnimation;

    @override
    void initState() {
        super.initState();
        _animationController = AnimationController(
            duration: const Duration(milliseconds: 150),
            vsync: this,
        );
        _scaleAnimation = Tween<double>(
            begin: 1.0,
            end: 0.9,
        ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
        ));
    }

    @override
    void dispose() {
        _animationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    _buildControlButton(
                        icon: widget.isMuted ? 'mic_off' : 'mic',
                        isActive: !widget.isMuted,
                        onTap: widget.onMuteToggle,
                        backgroundColor: widget.isMuted
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.surface,
                    ),
                    _buildControlButton(
                        icon: widget.isSpeakerOn ? 'volume_up' : 'phone',
                        isActive: widget.isSpeakerOn,
                        onTap: widget.onSpeakerToggle,
                        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    ),
                    _buildEndCallButton(),
                    _buildControlButton(
                        icon: 'note_add',
                        isActive: true,
                        onTap: widget.onShowNotes,
                        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    ),
                ],
            ),
        );
    }

    Widget _buildControlButton({
        required String icon,
        required bool isActive,
        required VoidCallback onTap,
        required Color backgroundColor,
    }) {
        return GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: onTap,
            child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                    return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                    BoxShadow(
                                        color:
                                        AppTheme.lightTheme.shadowColor.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                    ),
                                ],
                            ),
                            child: Center(
                                child: CustomIconWidget(
                                    iconName: icon,
                                    size: 6.w,
                                    color: isActive
                                        ? AppTheme.lightTheme.colorScheme.primary
                                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                            ),
                        ),
                    );
                },
            ),
        );
    }

    Widget _buildEndCallButton() {
        return GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: () => _showEndCallConfirmation(context),
            child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                    return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                            width: 18.w,
                            height: 18.w,
                            decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error,
                                shape: BoxShape.circle,
                                boxShadow: [
                                    BoxShadow(
                                        color: AppTheme.lightTheme.colorScheme.error
                                            .withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                    ),
                                ],
                            ),
                            child: Center(
                                child: CustomIconWidget(
                                    iconName: 'call_end',
                                    size: 7.w,
                                    color: AppTheme.lightTheme.colorScheme.onError,
                                ),
                            ),
                        ),
                    );
                },
            ),
        );
    }

    void _showEndCallConfirmation(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                        'End Call',
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    content: Text(
                        'Are you sure you want to end this consultation?',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                                'Cancel',
                                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                            ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                                widget.onEndCall();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
                            ),
                            child: Text(
                                'End Call',
                                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onError,
                                ),
                            ),
                        ),
                    ],
                );
            },
        );
    }
}
