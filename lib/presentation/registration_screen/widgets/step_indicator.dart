import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class StepIndicator extends StatelessWidget {
    final int currentStep;
    final int totalSteps;

    const StepIndicator({
        super.key,
        required this.currentStep,
        required this.totalSteps,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
                children: [
                    // Step Progress Bar
                    Row(
                        children: List.generate(totalSteps, (index) {
                            final isCompleted = index < currentStep;
                            final isCurrent = index == currentStep;

                            return Expanded(
                                child: Row(
                                    children: [
                                        Expanded(
                                            child: Container(
                                                height: 4,
                                                decoration: BoxDecoration(
                                                    color: isCompleted || isCurrent
                                                        ? theme.colorScheme.primary
                                                        : theme.colorScheme.outline
                                                        .withValues(alpha: 0.3),
                                                    borderRadius: BorderRadius.circular(2),
                                                ),
                                            ),
                                        ),
                                        if (index < totalSteps - 1) SizedBox(width: 1.w),
                                    ],
                                ),
                            );
                        }),
                    ),

                    SizedBox(height: 1.h),

                    // Step Numbers and Labels
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(totalSteps, (index) {
                            final isCompleted = index < currentStep;
                            final isCurrent = index == currentStep;
                            final stepLabel = _getStepLabel(index);

                            return Expanded(
                                child: Column(
                                    children: [
                                        Container(
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                                color: isCompleted
                                                    ? theme.colorScheme.primary
                                                    : isCurrent
                                                    ? theme.colorScheme.primary
                                                    .withValues(alpha: 0.2)
                                                    : theme.colorScheme.surface,
                                                border: Border.all(
                                                    color: isCompleted || isCurrent
                                                        ? theme.colorScheme.primary
                                                        : theme.colorScheme.outline
                                                        .withValues(alpha: 0.3),
                                                    width: 2,
                                                ),
                                                shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                                child: isCompleted
                                                    ? CustomIconWidget(
                                                    iconName: 'check',
                                                    size: 16,
                                                    color: theme.colorScheme.onPrimary,
                                                )
                                                    : Text(
                                                    '${index + 1}',
                                                    style: theme.textTheme.labelSmall?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: isCurrent
                                                            ? theme.colorScheme.primary
                                                            : theme.colorScheme.onSurfaceVariant,
                                                    ),
                                                ),
                                            ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                            stepLabel,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                                fontWeight:
                                                isCurrent ? FontWeight.w600 : FontWeight.w400,
                                                color: isCurrent
                                                    ? theme.colorScheme.primary
                                                    : theme.colorScheme.onSurfaceVariant,
                                            ),
                                            textAlign: TextAlign.center,
                                        ),
                                    ],
                                ),
                            );
                        }),
                    ),
                ],
            ),
        );
    }

    String _getStepLabel(int step) {
        switch (step) {
            case 0:
                return 'Personal\nInfo';
            case 1:
                return 'Professional\nDetails';
            case 2:
                return 'Account\nSecurity';
            case 3:
                return 'Terms &\nAgreement';
            default:
                return 'Step ${step + 1}';
        }
    }
}
