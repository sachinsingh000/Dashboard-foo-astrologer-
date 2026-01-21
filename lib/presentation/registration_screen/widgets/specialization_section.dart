import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SpecializationSection extends StatelessWidget {
  final List<String> selectedSpecializations;
  final ValueChanged<String> onSpecializationToggle;

  const SpecializationSection({
    super.key,
    required this.selectedSpecializations,
    required this.onSpecializationToggle,
  });

  static const List<Map<String, dynamic>> _specializations = [
    {
      'id': 'vedic',
      'name': 'Vedic Astrology',
      'icon': 'auto_awesome',
      'description': 'Traditional Hindu astrology system',
    },
    {
      'id': 'tarot',
      'name': 'Tarot Reading',
      'icon': 'style',
      'description': 'Card-based divination practice',
    },
    {
      'id': 'numerology',
      'name': 'Numerology',
      'icon': 'calculate',
      'description': 'Number-based life analysis',
    },
    {
      'id': 'palmistry',
      'name': 'Palmistry',
      'icon': 'back_hand',
      'description': 'Palm reading and analysis',
    },
    {
      'id': 'western',
      'name': 'Western Astrology',
      'icon': 'public',
      'description': 'Zodiac-based astrology system',
    },
    {
      'id': 'chinese',
      'name': 'Chinese Astrology',
      'icon': 'yin_yang',
      'description': 'Traditional Chinese zodiac system',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Specializations *',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 2.w),
              Tooltip(
                message: 'Select at least one specialization',
                child: CustomIconWidget(
                  iconName: 'info_outline',
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose your areas of expertise (select multiple)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Specialization Chips
          Wrap(
            spacing: 2.w,
            runSpacing: 1.5.h,
            children: _specializations.map((specialization) {
              final isSelected =
                  selectedSpecializations.contains(specialization['id']);

              return GestureDetector(
                onTap: () => onSpecializationToggle(specialization['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: specialization['icon'],
                            size: 20,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 2.w),
                          Flexible(
                            child: Text(
                              specialization['name'],
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName: 'check_circle',
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        specialization['description'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          if (selectedSpecializations.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    size: 16,
                    color: theme.colorScheme.tertiary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      '${selectedSpecializations.length} specialization${selectedSpecializations.length > 1 ? 's' : ''} selected',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
