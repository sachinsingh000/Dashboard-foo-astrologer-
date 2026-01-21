import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkillsSectionWidget extends StatefulWidget {
  final List<String> selectedSkills;
  final Function(List<String>) onSkillsChanged;
  final VoidCallback onSave;
  final bool isLoading;

  const SkillsSectionWidget({
    super.key,
    required this.selectedSkills,
    required this.onSkillsChanged,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<SkillsSectionWidget> createState() => _SkillsSectionWidgetState();
}

class _SkillsSectionWidgetState extends State<SkillsSectionWidget> {
  final List<Map<String, dynamic>> _availableSkills = [
    {'name': 'Vedic Astrology', 'level': 'Expert', 'icon': 'auto_awesome'},
    {'name': 'Tarot Reading', 'level': 'Advanced', 'icon': 'style'},
    {'name': 'Numerology', 'level': 'Intermediate', 'icon': 'calculate'},
    {'name': 'Palmistry', 'level': 'Expert', 'icon': 'back_hand'},
    {'name': 'Western Astrology', 'level': 'Advanced', 'icon': 'public'},
    {'name': 'Vastu Shastra', 'level': 'Intermediate', 'icon': 'home'},
    {'name': 'Gemstone Therapy', 'level': 'Beginner', 'icon': 'diamond'},
    {'name': 'Horoscope Matching', 'level': 'Expert', 'icon': 'favorite'},
    {'name': 'Career Guidance', 'level': 'Advanced', 'icon': 'work'},
    {'name': 'Relationship Counseling', 'level': 'Advanced', 'icon': 'people'},
  ];

  late List<String> _tempSelectedSkills;

  @override
  void initState() {
    super.initState();
    _tempSelectedSkills = List.from(widget.selectedSkills);
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'expert':
        return Theme.of(context).colorScheme.tertiary;
      case 'advanced':
        return Theme.of(context).colorScheme.primary;
      case 'intermediate':
        return AppTheme.getWarningColor(context);
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
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
                iconName: 'star',
                size: 6.w,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Text(
                'Skills & Specializations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Select your areas of expertise (up to 5 skills)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _availableSkills.map((skill) {
              final isSelected = _tempSelectedSkills.contains(skill['name']);
              final canSelect = _tempSelectedSkills.length < 5 || isSelected;

              return GestureDetector(
                onTap: canSelect
                    ? () {
                  setState(() {
                    if (isSelected) {
                      _tempSelectedSkills.remove(skill['name']);
                    } else {
                      _tempSelectedSkills.add(skill['name']);
                    }
                  });
                  widget.onSkillsChanged(_tempSelectedSkills);
                }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : canSelect
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.5),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: skill['icon'],
                        size: 4.w,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : canSelect
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            skill['name'],
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : canSelect
                                  ? Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 0.2.h),
                            decoration: BoxDecoration(
                              color: _getLevelColor(skill['level'])
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              skill['level'],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                color: _getLevelColor(skill['level']),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isSelected) ...[
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'check_circle',
                          size: 3.w,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_tempSelectedSkills.length}/5 skills selected',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _tempSelectedSkills.length >= 5
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurfaceVariant,
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
