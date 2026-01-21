import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HelpfulTipsModal extends StatelessWidget {
  const HelpfulTipsModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HelpfulTipsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Document Upload Tips',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            height: 1,
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context: context,
                    title: 'Photo Quality Requirements',
                    icon: 'photo_camera',
                    tips: [
                      'Use good lighting - natural light works best',
                      'Ensure document is flat and not folded',
                      'Fill the entire frame with your document',
                      'Avoid shadows, glare, and reflections',
                      'Make sure all text is clearly readable',
                      'Use a dark background for better contrast',
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildSection(
                    context: context,
                    title: 'Accepted Document Types',
                    icon: 'description',
                    tips: [
                      'Identity Proof: Aadhaar, PAN, Passport, Driving License',
                      'Address Proof: Utility bills, Bank statements, Rental agreement',
                      'Professional Certificates: Astrology certifications, Course completion',
                      'File formats: JPG, PNG, PDF (max 5MB each)',
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildSection(
                    context: context,
                    title: 'Processing Timeline',
                    icon: 'schedule',
                    tips: [
                      'Initial review: 24-48 hours',
                      'Additional verification (if needed): 2-3 business days',
                      'You\'ll receive notifications about status updates',
                      'Approved documents cannot be changed later',
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildSection(
                    context: context,
                    title: 'Common Rejection Reasons',
                    icon: 'error_outline',
                    tips: [
                      'Blurry or unclear images',
                      'Document partially cut off in photo',
                      'Expired documents',
                      'Mismatched information between documents',
                      'Poor lighting making text unreadable',
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.getAccentColor(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Need Help?',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'If you\'re having trouble with document upload or verification, contact our support team for assistance.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigate to support
                            },
                            icon: CustomIconWidget(
                              iconName: 'support_agent',
                              color: theme.colorScheme.primary,
                              size: 18,
                            ),
                            label: const Text('Contact Support'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String icon,
    required List<String> tips,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...tips
            .map((tip) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 1.5.w,
                        height: 1.5.w,
                        margin: EdgeInsets.only(top: 1.h, right: 3.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tip,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
