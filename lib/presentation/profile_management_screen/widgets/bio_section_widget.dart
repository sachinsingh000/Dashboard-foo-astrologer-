import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BioSectionWidget extends StatefulWidget {
    final String bio;
    final Function(String) onBioChanged;
    final VoidCallback onSave;
    final bool isLoading;

    const BioSectionWidget({
        super.key,
        required this.bio,
        required this.onBioChanged,
        required this.onSave,
        this.isLoading = false,
    });

    @override
    State<BioSectionWidget> createState() => _BioSectionWidgetState();
}

class _BioSectionWidgetState extends State<BioSectionWidget> {
    late TextEditingController _bioController;
    bool _isExpanded = false;
    final int _maxCharacters = 500;

    @override
    void initState() {
        super.initState();
        _bioController = TextEditingController(text: widget.bio);
    }

    @override
    void dispose() {
        _bioController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                        blurRadius: 8,
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
                                iconName: 'person',
                                size: 6.w,
                                color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                                'Professional Bio',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                ),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () => setState(() => _isExpanded = !_isExpanded),
                                child: CustomIconWidget(
                                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                                    size: 6.w,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: 2.h),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _isExpanded ? null : 15.h,
                        child: TextField(
                            controller: _bioController,
                            maxLines: _isExpanded ? 10 : 6,
                            maxLength: _maxCharacters,
                            onChanged: widget.onBioChanged,
                            decoration: InputDecoration(
                                hintText:
                                'Tell clients about your expertise, experience, and approach to astrology...',
                                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.outline,
                                    ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.outline,
                                    ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2,
                                    ),
                                ),
                                counterText: '${_bioController.text.length}/$_maxCharacters',
                                counterStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _bioController.text.length > _maxCharacters * 0.9
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                        children: [
                            Expanded(
                                child: Text(
                                    'Tip: A detailed bio helps clients understand your expertise and builds trust',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                ),
                            ),
                            SizedBox(width: 3.w),
                            ElevatedButton(
                                onPressed: widget.isLoading ? null : widget.onSave,
                                style: ElevatedButton.styleFrom(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                    ),
                                ),
                                child: widget.isLoading
                                    ? SizedBox(
                                    width: 4.w,
                                    height: 4.w,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).colorScheme.onPrimary,
                                        ),
                                    ),
                                )
                                    : Text(
                                    'Save',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
        );
    }
}
