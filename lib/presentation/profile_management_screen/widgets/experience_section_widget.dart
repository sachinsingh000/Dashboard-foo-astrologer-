import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExperienceSectionWidget extends StatefulWidget {
    final int yearsOfExperience;
    final List<String> certifications;
    final Function(int) onExperienceChanged;
    final Function(List<String>) onCertificationsChanged;
    final VoidCallback onSave;
    final bool isLoading;

    const ExperienceSectionWidget({
        super.key,
        required this.yearsOfExperience,
        required this.certifications,
        required this.onExperienceChanged,
        required this.onCertificationsChanged,
        required this.onSave,
        this.isLoading = false,
    });

    @override
    State<ExperienceSectionWidget> createState() =>
        _ExperienceSectionWidgetState();
}

class _ExperienceSectionWidgetState extends State<ExperienceSectionWidget> {
    late int _tempYearsOfExperience;
    late List<String> _tempCertifications;
    bool _isUploadingCertification = false;

    @override
    void initState() {
        super.initState();
        _tempYearsOfExperience = widget.yearsOfExperience;
        _tempCertifications = List.from(widget.certifications);
    }

    Future<void> _uploadCertification() async {
        setState(() {
            _isUploadingCertification = true;
        });

        try {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                allowMultiple: false,
            );

            if (result != null && result.files.isNotEmpty) {
                final fileName = result.files.first.name;
                setState(() {
                    _tempCertifications.add(fileName);
                });
                widget.onCertificationsChanged(_tempCertifications);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Certification uploaded: $fileName'),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                );
            }
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text('Failed to upload certification'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                ),
            );
        } finally {
            setState(() {
                _isUploadingCertification = false;
            });
        }
    }

    void _removeCertification(int index) {
        setState(() {
            _tempCertifications.removeAt(index);
        });
        widget.onCertificationsChanged(_tempCertifications);
    }

    String _getExperienceLevel(int years) {
        if (years == 0) return 'Beginner';
        if (years <= 2) return 'Novice';
        if (years <= 5) return 'Intermediate';
        if (years <= 10) return 'Advanced';
        if (years <= 20) return 'Expert';
        return 'Master';
    }

    Color _getExperienceLevelColor(int years) {
        if (years == 0) return Theme.of(context).colorScheme.onSurfaceVariant;
        if (years <= 2) return AppTheme.getWarningColor(context);
        if (years <= 5) return Theme.of(context).colorScheme.primary;
        if (years <= 10) return Theme.of(context).colorScheme.tertiary;
        if (years <= 20) return Theme.of(context).colorScheme.secondary;
        return Theme.of(context).colorScheme.error;
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
                                iconName: 'school',
                                size: 6.w,
                                color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                                'Experience & Certifications',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: 3.h),

                    // Years of Experience Section
                    Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                            ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'timeline',
                                            size: 5.w,
                                            color: Theme.of(context).colorScheme.primary,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                            'Years of Practice',
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                    children: [
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(
                                                        '$_tempYearsOfExperience years',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall
                                                            ?.copyWith(
                                                            fontWeight: FontWeight.w700,
                                                            color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 2.w, vertical: 0.5.h),
                                                        decoration: BoxDecoration(
                                                            color: _getExperienceLevelColor(
                                                                _tempYearsOfExperience)
                                                                .withValues(alpha: 0.2),
                                                            borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        child: Text(
                                                            _getExperienceLevel(_tempYearsOfExperience),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .labelSmall
                                                                ?.copyWith(
                                                                color: _getExperienceLevelColor(
                                                                    _tempYearsOfExperience),
                                                                fontWeight: FontWeight.w600,
                                                            ),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: 2.h),
                                Slider(
                                    value: _tempYearsOfExperience.toDouble(),
                                    min: 0,
                                    max: 50,
                                    divisions: 50,
                                    onChanged: (value) {
                                        setState(() {
                                            _tempYearsOfExperience = value.toInt();
                                        });
                                        widget.onExperienceChanged(_tempYearsOfExperience);
                                    },
                                    activeColor: Theme.of(context).colorScheme.primary,
                                    inactiveColor: Theme.of(context).colorScheme.outline,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text(
                                            '0 years',
                                            style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                        Text(
                                            '50+ years',
                                            style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),

                    SizedBox(height: 3.h),

                    // Certifications Section
                    Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                            ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'verified',
                                            size: 5.w,
                                            color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                            'Certifications',
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                        const Spacer(),
                                        OutlinedButton.icon(
                                            onPressed: _isUploadingCertification
                                                ? null
                                                : _uploadCertification,
                                            icon: _isUploadingCertification
                                                ? SizedBox(
                                                width: 4.w,
                                                height: 4.w,
                                                child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                        Theme.of(context).colorScheme.primary,
                                                    ),
                                                ),
                                            )
                                                : CustomIconWidget(
                                                iconName: 'upload_file',
                                                size: 4.w,
                                                color: Theme.of(context).colorScheme.primary,
                                            ),
                                            label: Text(
                                                'Upload',
                                                style: Theme.of(context).textTheme.labelSmall,
                                            ),
                                            style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w, vertical: 1.h),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: 2.h),
                                if (_tempCertifications.isEmpty) ...[
                                    Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(4.w),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline
                                                    .withValues(alpha: 0.3),
                                                style: BorderStyle.solid,
                                            ),
                                        ),
                                        child: Column(
                                            children: [
                                                CustomIconWidget(
                                                    iconName: 'description',
                                                    size: 8.w,
                                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                ),
                                                SizedBox(height: 1.h),
                                                Text(
                                                    'No certifications uploaded',
                                                    style:
                                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                    ),
                                                ),
                                                Text(
                                                    'Upload certificates to build trust with clients',
                                                    style:
                                                    Theme.of(context).textTheme.labelSmall?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ] else ...[
                                    ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _tempCertifications.length,
                                        separatorBuilder: (context, index) => SizedBox(height: 1.h),
                                        itemBuilder: (context, index) {
                                            final certification = _tempCertifications[index];
                                            return Container(
                                                padding: EdgeInsets.all(3.w),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.surface,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .outline
                                                            .withValues(alpha: 0.3),
                                                    ),
                                                ),
                                                child: Row(
                                                    children: [
                                                        Container(
                                                            padding: EdgeInsets.all(2.w),
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(context)
                                                                    .colorScheme
                                                                    .tertiary
                                                                    .withValues(alpha: 0.2),
                                                                borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: CustomIconWidget(
                                                                iconName:
                                                                certification.toLowerCase().endsWith('.pdf')
                                                                    ? 'picture_as_pdf'
                                                                    : 'image',
                                                                size: 5.w,
                                                                color: Theme.of(context).colorScheme.tertiary,
                                                            ),
                                                        ),
                                                        SizedBox(width: 3.w),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Text(
                                                                        certification,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall
                                                                            ?.copyWith(
                                                                            fontWeight: FontWeight.w500,
                                                                        ),
                                                                        overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    Text(
                                                                        'Uploaded on ${DateTime.now().toString().split(' ')[0]}',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .labelSmall
                                                                            ?.copyWith(
                                                                            color: Theme.of(context)
                                                                                .colorScheme
                                                                                .onSurfaceVariant,
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () => _removeCertification(index),
                                                            icon: CustomIconWidget(
                                                                iconName: 'delete',
                                                                size: 5.w,
                                                                color: Theme.of(context).colorScheme.error,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            );
                                        },
                                    ),
                                ],
                                SizedBox(height: 2.h),
                                Text(
                                    'Supported formats: PDF, JPG, PNG (Max 5MB each)',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                ),
                            ],
                        ),
                    ),

                    SizedBox(height: 3.h),
                    Row(
                        children: [
                            Expanded(
                                child: Text(
                                    '${_tempCertifications.length} certification${_tempCertifications.length != 1 ? 's' : ''} uploaded',
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
