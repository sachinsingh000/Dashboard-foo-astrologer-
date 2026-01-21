import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FormattingToolbarWidget extends StatelessWidget {
    final bool isBold;
    final bool isItalic;
    final bool isUnderline;
    final bool isBulletList;
    final VoidCallback onBoldPressed;
    final VoidCallback onItalicPressed;
    final VoidCallback onUnderlinePressed;
    final VoidCallback onBulletListPressed;
    final VoidCallback onAddHeadingPressed;
    final VoidCallback onAddImagePressed;
    final VoidCallback onUndoPressed;
    final VoidCallback onRedoPressed;

    const FormattingToolbarWidget({
        super.key,
        required this.isBold,
        required this.isItalic,
        required this.isUnderline,
        required this.isBulletList,
        required this.onBoldPressed,
        required this.onItalicPressed,
        required this.onUnderlinePressed,
        required this.onBulletListPressed,
        required this.onAddHeadingPressed,
        required this.onAddImagePressed,
        required this.onUndoPressed,
        required this.onRedoPressed,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Container(
            height: 7.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                    bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                    ),
                ),
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: [
                        _buildToolbarButton(
                            context: context,
                            icon: 'undo',
                            onPressed: onUndoPressed,
                            tooltip: 'Undo',
                        ),
                        _buildToolbarButton(
                            context: context,
                            icon: 'redo',
                            onPressed: onRedoPressed,
                            tooltip: 'Redo',
                        ),
                        _buildDivider(theme),
                        _buildToolbarButton(
                            context: context,
                            icon: 'format_bold',
                            onPressed: onBoldPressed,
                            isActive: isBold,
                            tooltip: 'Bold',
                        ),
                        _buildToolbarButton(
                            context: context,
                            icon: 'format_italic',
                            onPressed: onItalicPressed,
                            isActive: isItalic,
                            tooltip: 'Italic',
                        ),
                        _buildToolbarButton(
                            context: context,
                            icon: 'format_underlined',
                            onPressed: onUnderlinePressed,
                            isActive: isUnderline,
                            tooltip: 'Underline',
                        ),
                        _buildDivider(theme),
                        _buildToolbarButton(
                            context: context,
                            icon: 'format_list_bulleted',
                            onPressed: onBulletListPressed,
                            isActive: isBulletList,
                            tooltip: 'Bullet List',
                        ),
                        _buildToolbarButton(
                            context: context,
                            icon: 'title',
                            onPressed: onAddHeadingPressed,
                            tooltip: 'Add Heading',
                        ),
                        _buildDivider(theme),
                        _buildToolbarButton(
                            context: context,
                            icon: 'image',
                            onPressed: onAddImagePressed,
                            tooltip: 'Insert Image',
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildToolbarButton({
        required BuildContext context,
        required String icon,
        required VoidCallback onPressed,
        bool isActive = false,
        required String tooltip,
    }) {
        final theme = Theme.of(context);

        return Tooltip(
            message: tooltip,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: onPressed,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                            width: 10.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                                color: isActive
                                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: isActive
                                    ? Border.all(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                    width: 1,
                                )
                                    : null,
                            ),
                            child: Center(
                                child: CustomIconWidget(
                                    iconName: icon,
                                    color: isActive
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                ),
                            ),
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _buildDivider(ThemeData theme) {
        return Container(
            width: 1,
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
        );
    }
}
