
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_capture_widget.dart';
import './widgets/document_upload_card.dart';
import './widgets/helpful_tips_modal.dart';
import './widgets/progress_stepper.dart';

class KycVerificationScreen extends StatefulWidget {
    const KycVerificationScreen({super.key});

    @override
    State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen>
    with TickerProviderStateMixin {
    late AnimationController _celebrationController;
    late Animation<double> _celebrationAnimation;

    int _currentStep = 0;
    bool _isSubmitting = false;
    bool _allDocumentsUploaded = false;

    // Document status tracking
    final Map<String, DocumentUploadData> _documents = {
        'identity': DocumentUploadData(
            title: 'Identity Proof',
            description:
            'Upload a clear photo of your government-issued ID (Aadhaar, PAN, Passport, or Driving License)',
            acceptedFormats: ['jpg', 'png', 'pdf'],
            isRequired: true,
            status: DocumentStatus.notUploaded,
        ),
        'address': DocumentUploadData(
            title: 'Address Proof',
            description:
            'Upload a recent utility bill, bank statement, or rental agreement showing your current address',
            acceptedFormats: ['jpg', 'png', 'pdf'],
            isRequired: true,
            status: DocumentStatus.notUploaded,
        ),
        'professional': DocumentUploadData(
            title: 'Professional Certificates',
            description:
            'Upload your astrology certifications, course completion certificates, or relevant qualifications',
            acceptedFormats: ['jpg', 'png', 'pdf'],
            isRequired: false,
            status: DocumentStatus.notUploaded,
        ),
    };

    final List<StepData> _steps = [
        StepData(
            title: 'Identity Proof',
            description: 'Upload your government-issued identity document',
        ),
        StepData(
            title: 'Address Proof',
            description: 'Verify your current residential address',
        ),
        StepData(
            title: 'Professional Certificates',
            description: 'Add your astrology qualifications (optional)',
        ),
    ];

    @override
    void initState() {
        super.initState();
        _celebrationController = AnimationController(
            duration: const Duration(milliseconds: 1500),
            vsync: this,
        );
        _celebrationAnimation = CurvedAnimation(
            parent: _celebrationController,
            curve: Curves.elasticOut,
        );
        _updateCurrentStep();
    }

    @override
    void dispose() {
        _celebrationController.dispose();
        super.dispose();
    }

    void _updateCurrentStep() {
        int step = 0;
        if (_documents['identity']!.status == DocumentStatus.approved ||
            _documents['identity']!.status == DocumentStatus.underReview) {
            step = 1;
        }
        if (_documents['address']!.status == DocumentStatus.approved ||
            _documents['address']!.status == DocumentStatus.underReview) {
            step = 2;
        }

        setState(() {
            _currentStep = step;
            _allDocumentsUploaded =
                _documents['identity']!.uploadedFileName != null &&
                    _documents['address']!.uploadedFileName != null;
        });
    }

    Future<void> _handleDocumentUpload(String documentType) async {
        final result = await showModalBottomSheet<XFile?>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildUploadOptionsSheet(documentType),
        );

        if (result != null) {
            await _processUploadedImage(documentType, result);
        }
    }

    Widget _buildUploadOptionsSheet(String documentType) {
        final theme = Theme.of(context);

        return Container(
            height: 40.h,
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                ),
            ),
            child: Column(
                children: [
                    Container(
                        width: 12.w,
                        height: 0.5.h,
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                            'Upload ${_documents[documentType]!.title}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                            ),
                        ),
                    ),
                    SizedBox(height: 3.h),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Column(
                                children: [
                                    _buildUploadOption(
                                        icon: 'camera_alt',
                                        title: 'Take Photo',
                                        subtitle: 'Capture document with camera',
                                        onTap: () => _openCamera(documentType),
                                    ),
                                    SizedBox(height: 2.h),
                                    _buildUploadOption(
                                        icon: 'photo_library',
                                        title: 'Choose from Gallery',
                                        subtitle: 'Select from your photos',
                                        onTap: () => _pickFromGallery(documentType),
                                    ),
                                    SizedBox(height: 2.h),
                                    _buildUploadOption(
                                        icon: 'description',
                                        title: 'Upload PDF',
                                        subtitle: 'Select PDF document',
                                        onTap: () => _pickPdfFile(documentType),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildUploadOption({
        required String icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
    }) {
        final theme = Theme.of(context);

        return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                    children: [
                        Container(
                            width: 12.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                                iconName: icon,
                                color: theme.colorScheme.onPrimaryContainer,
                                size: 24,
                            ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        title,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                        subtitle,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        CustomIconWidget(
                            iconName: 'arrow_forward_ios',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 16,
                        ),
                    ],
                ),
            ),
        );
    }

    Future<void> _openCamera(String documentType) async {
        Navigator.pop(context);

        final result = await Navigator.push<XFile>(
            context,
            MaterialPageRoute(
                builder: (context) => CameraCaptureWidget(
                    onImageCaptured: (image) {
                        Navigator.pop(context, image);
                    },
                    onCancel: () {
                        Navigator.pop(context);
                    },
                ),
            ),
        );

        if (result != null) {
            await _processUploadedImage(documentType, result);
        }
    }

    Future<void> _pickFromGallery(String documentType) async {
        Navigator.pop(context);

        try {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
            );

            if (image != null) {
                await _processUploadedImage(documentType, image);
            }
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to pick image: ${e.toString()}'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                ),
            );
        }
    }

    Future<void> _pickPdfFile(String documentType) async {
        Navigator.pop(context);

        // For demo purposes, simulate PDF selection
        final fileName = '${documentType}_document.pdf';
        setState(() {
            _documents[documentType] = _documents[documentType]!.copyWith(
                uploadedFileName: fileName,
                status: DocumentStatus.pending,
            );
        });
        _updateCurrentStep();

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('PDF uploaded successfully: $fileName'),
                backgroundColor: AppTheme.getSuccessColor(context),
            ),
        );
    }

    Future<void> _processUploadedImage(String documentType, XFile image) async {
        try {
            XFile? processedImage = image;

            // Crop image if not on web
            if (!kIsWeb) {
                final croppedFile = await ImageCropper().cropImage(
                    sourcePath: image.path,
                    aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 10),
                    uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'Crop Document',
                            toolbarColor: Theme.of(context).colorScheme.primary,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false,
                        ),
                        IOSUiSettings(
                            title: 'Crop Document',
                            minimumAspectRatio: 1.0,
                        ),
                    ],
                );

                if (croppedFile != null) {
                    processedImage = XFile(croppedFile.path);
                }
            }

            // Update document status
            final fileName = processedImage.name;
            setState(() {
                _documents[documentType] = _documents[documentType]!.copyWith(
                    uploadedFileName: fileName,
                    status: DocumentStatus.pending,
                );
            });

            _updateCurrentStep();

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Document uploaded successfully'),
                    backgroundColor: AppTheme.getSuccessColor(context),
                ),
            );
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to process image: ${e.toString()}'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                ),
            );
        }
    }

    Future<void> _submitForReview() async {
        setState(() {
            _isSubmitting = true;
        });

        // Simulate submission process
        await Future.delayed(const Duration(seconds: 2));

        // Update all uploaded documents to under review
        setState(() {
            for (final key in _documents.keys) {
                if (_documents[key]!.uploadedFileName != null) {
                    _documents[key] = _documents[key]!.copyWith(
                        status: DocumentStatus.underReview,
                    );
                }
            }
            _isSubmitting = false;
        });

        _updateCurrentStep();
        _showSubmissionSuccessDialog();
    }

    void _showSubmissionSuccessDialog() {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        AnimatedBuilder(
                            animation: _celebrationAnimation,
                            builder: (context, child) {
                                return Transform.scale(
                                    scale: _celebrationAnimation.value,
                                    child: Container(
                                        width: 20.w,
                                        height: 10.h,
                                        decoration: BoxDecoration(
                                            color: AppTheme.getSuccessColor(context),
                                            shape: BoxShape.circle,
                                        ),
                                        child: CustomIconWidget(
                                            iconName: 'check',
                                            color: Colors.white,
                                            size: 32,
                                        ),
                                    ),
                                );
                            },
                        ),
                        SizedBox(height: 3.h),
                        Text(
                            'Documents Submitted!',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                            'Your documents have been submitted for review. You\'ll receive a notification within 24-48 hours about the verification status.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                        ),
                    ],
                ),
                actions: [
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(context, '/dashboard-screen');
                            },
                            child: const Text('Continue to Dashboard'),
                        ),
                    ),
                ],
            ),
        );

        _celebrationController.forward();
    }

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Scaffold(
            appBar: AppBar(
                title: const Text('KYC Verification'),
                actions: [
                    IconButton(
                        onPressed: () => HelpfulTipsModal.show(context),
                        icon: CustomIconWidget(
                            iconName: 'help_outline',
                            color: theme.colorScheme.onSurface,
                            size: 24,
                        ),
                    ),
                ],
            ),
            body: Column(
                children: [
                    // Progress stepper
                    ProgressStepper(
                        currentStep: _currentStep,
                        steps: _steps,
                    ),

                    // Document upload cards
                    Expanded(
                        child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            children: [
                                DocumentUploadCard(
                                    title: _documents['identity']!.title,
                                    description: _documents['identity']!.description,
                                    acceptedFormats: _documents['identity']!.acceptedFormats,
                                    isRequired: _documents['identity']!.isRequired,
                                    status: _documents['identity']!.status,
                                    rejectionReason: _documents['identity']!.rejectionReason,
                                    uploadedFileName: _documents['identity']!.uploadedFileName,
                                    onUpload: () => _handleDocumentUpload('identity'),
                                    onRetry:
                                    _documents['identity']!.status == DocumentStatus.rejected
                                        ? () => _handleDocumentUpload('identity')
                                        : null,
                                ),
                                DocumentUploadCard(
                                    title: _documents['address']!.title,
                                    description: _documents['address']!.description,
                                    acceptedFormats: _documents['address']!.acceptedFormats,
                                    isRequired: _documents['address']!.isRequired,
                                    status: _documents['address']!.status,
                                    rejectionReason: _documents['address']!.rejectionReason,
                                    uploadedFileName: _documents['address']!.uploadedFileName,
                                    onUpload: () => _handleDocumentUpload('address'),
                                    onRetry:
                                    _documents['address']!.status == DocumentStatus.rejected
                                        ? () => _handleDocumentUpload('address')
                                        : null,
                                ),
                                DocumentUploadCard(
                                    title: _documents['professional']!.title,
                                    description: _documents['professional']!.description,
                                    acceptedFormats: _documents['professional']!.acceptedFormats,
                                    isRequired: _documents['professional']!.isRequired,
                                    status: _documents['professional']!.status,
                                    rejectionReason: _documents['professional']!.rejectionReason,
                                    uploadedFileName:
                                    _documents['professional']!.uploadedFileName,
                                    onUpload: () => _handleDocumentUpload('professional'),
                                    onRetry: _documents['professional']!.status ==
                                        DocumentStatus.rejected
                                        ? () => _handleDocumentUpload('professional')
                                        : null,
                                ),
                                SizedBox(height: 4.h),
                            ],
                        ),
                    ),
                ],
            ),
            bottomNavigationBar: _allDocumentsUploaded
                ? Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                        BoxShadow(
                            color: theme.shadowColor.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                        ),
                    ],
                ),
                child: SafeArea(
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitForReview,
                            child: _isSubmitting
                                ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                theme.colorScheme.onPrimary,
                                            ),
                                        ),
                                    ),
                                    SizedBox(width: 2.w),
                                    const Text('Submitting...'),
                                ],
                            )
                                : const Text('Submit for Review'),
                        ),
                    ),
                ),
            )
                : null,
        );
    }
}

class DocumentUploadData {
    final String title;
    final String description;
    final List<String> acceptedFormats;
    final bool isRequired;
    final DocumentStatus status;
    final String? rejectionReason;
    final String? uploadedFileName;

    const DocumentUploadData({
        required this.title,
        required this.description,
        required this.acceptedFormats,
        required this.isRequired,
        required this.status,
        this.rejectionReason,
        this.uploadedFileName,
    });

    DocumentUploadData copyWith({
        String? title,
        String? description,
        List<String>? acceptedFormats,
        bool? isRequired,
        DocumentStatus? status,
        String? rejectionReason,
        String? uploadedFileName,
    }) {
        return DocumentUploadData(
            title: title ?? this.title,
            description: description ?? this.description,
            acceptedFormats: acceptedFormats ?? this.acceptedFormats,
            isRequired: isRequired ?? this.isRequired,
            status: status ?? this.status,
            rejectionReason: rejectionReason ?? this.rejectionReason,
            uploadedFileName: uploadedFileName ?? this.uploadedFileName,
        );
    }
}
