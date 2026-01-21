import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressStepper extends StatelessWidget {
    final int currentStep;
    final List<StepData> steps;

    const ProgressStepper({
        super.key,
        required this.currentStep,
        required this.steps,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
                children: [
                    Row(
                        children: List.generate(steps.length, (index) {
                            final isActive = index <= currentStep;
                            final isCompleted = index < currentStep;
                            final isCurrent = index == currentStep;

                            return Expanded(
                                child: Row(
                                    children: [
                                        Expanded(
                                            child: Column(
                                                children: [
                                                    Container(
                                                        width: 10.w,
                                                        height: 5.h,
                                                        decoration: BoxDecoration(
                                                            color: isCompleted
                                                                ? AppTheme.getSuccessColor(context)
                                                                : isCurrent
                                                                ? theme.colorScheme.primary
                                                                : theme.colorScheme.outline
                                                                .withValues(alpha: 0.3),
                                                            shape: BoxShape.circle,
                                                            border: isCurrent
                                                                ? Border.all(
                                                                color: theme.colorScheme.primary,
                                                                width: 2,
                                                            )
                                                                : null,
                                                        ),
                                                        child: Center(
                                                            child: isCompleted
                                                                ? CustomIconWidget(
                                                                iconName: 'check',
                                                                color: Colors.white,
                                                                size: 18,
                                                            )
                                                                : Text(
                                                                '${index + 1}',
                                                                style:
                                                                theme.textTheme.labelMedium?.copyWith(
                                                                    color: isActive
                                                                        ? Colors.white
                                                                        : theme
                                                                        .colorScheme.onSurfaceVariant,
                                                                    fontWeight: FontWeight.w600,
                                                                ),
                                                            ),
                                                        ),
                                                    ),
                                                    SizedBox(height: 1.h),
                                                    Text(
                                                        steps[index].title,
                                                        style: theme.textTheme.labelSmall?.copyWith(
                                                            color: isActive
                                                                ? theme.colorScheme.onSurface
                                                                : theme.colorScheme.onSurfaceVariant,
                                                            fontWeight:
                                                            isActive ? FontWeight.w600 : FontWeight.w400,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                    ),
                                                ],
                                            ),
                                        ),
                                        if (index < steps.length - 1)
                                            Expanded(
                                                child: Container(
                                                    height: 2,
                                                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                                                    decoration: BoxDecoration(
                                                        color: isCompleted
                                                            ? AppTheme.getSuccessColor(context)
                                                            : theme.colorScheme.outline
                                                            .withValues(alpha: 0.3),
                                                        borderRadius: BorderRadius.circular(1),
                                                    ),
                                                ),
                                            ),
                                    ],
                                ),
                            );
                        }),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                            color: AppTheme.getAccentColor(context),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    'Current Step: ${steps[currentStep].title}',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                    steps[currentStep].description,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}

class StepData {
    final String title;
    final String description;

    const StepData({
        required this.title,
        required this.description,
    });
}
