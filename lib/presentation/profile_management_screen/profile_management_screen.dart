import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/availability_section_widget.dart';
import './widgets/bio_section_widget.dart';
import './widgets/experience_section_widget.dart';
import './widgets/languages_section_widget.dart';
import './widgets/pricing_section_widget.dart';
import './widgets/profile_completion_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/skills_section_widget.dart';

class ProfileManagementScreen extends StatefulWidget {
    const ProfileManagementScreen({super.key});

    @override
    State<ProfileManagementScreen> createState() =>
        _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen>
    with TickerProviderStateMixin {
    late TabController _tabController;
    final ScrollController _scrollController = ScrollController();

    // Camera related variables
    List<CameraDescription> _cameras = [];
    CameraController? _cameraController;
    XFile? _capturedImage;
    bool _isCameraInitialized = false;

    // Profile data
    final Map<String, dynamic> _profileData = {
        'name': 'Dr. Priya Sharma',
        'profileImage':
        'https://images.pexels.com/photos/3762800/pexels-photo-3762800.jpeg?auto=compress&cs=tinysrgb&w=400',
        'isVerified': true,
        'bio':
        'Experienced Vedic astrologer with over 15 years of practice. Specializing in career guidance, relationship counseling, and spiritual healing. I combine traditional wisdom with modern insights to provide accurate predictions and practical solutions.',
        'selectedSkills': [
            'Vedic Astrology',
            'Tarot Reading',
            'Career Guidance',
            'Relationship Counseling'
        ],
        'selectedLanguages': ['English', 'Hindi', 'Sanskrit'],
        'pricing': {
            'chat': 2.50,
            'audio': 4.00,
            'video': 6.50,
            'report': 75.00,
        },
        'yearsOfExperience': 15,
        'certifications': [
            'Vedic_Astrology_Certificate.pdf',
            'Tarot_Master_Diploma.pdf'
        ],
        'weeklySchedule': {
            'Monday': ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
            'Tuesday': ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
            'Wednesday': ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
            'Thursday': ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
            'Friday': ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
            'Saturday': ['10:00', '11:00', '15:00', '16:00'],
            'Sunday': [],
        },
        'holidays': <DateTime>[],
    };

    // Loading states
    final Map<String, bool> _loadingStates = {
        'bio': false,
        'skills': false,
        'languages': false,
        'pricing': false,
        'experience': false,
        'availability': false,
    };

    int _currentBottomNavIndex = 4; // Profile tab

    @override
    void initState() {
        super.initState();
        _tabController = TabController(length: 6, vsync: this);
        _initializeCamera();
    }

    @override
    void dispose() {
        _tabController.dispose();
        _scrollController.dispose();
        _cameraController?.dispose();
        super.dispose();
    }

    // Camera initialization
    Future<void> _initializeCamera() async {
        try {
            if (!kIsWeb && await _requestCameraPermission()) {
                _cameras = await availableCameras();
                if (_cameras.isNotEmpty) {
                    final camera = _cameras.firstWhere(
                            (c) => c.lensDirection == CameraLensDirection.back,
                        orElse: () => _cameras.first,
                    );

                    _cameraController = CameraController(
                        camera,
                        ResolutionPreset.high,
                    );

                    await _cameraController!.initialize();
                    await _applySettings();

                    if (mounted) {
                        setState(() {
                            _isCameraInitialized = true;
                        });
                    }
                }
            }
        } catch (e) {
            debugPrint('Camera initialization error: $e');
        }
    }

    Future<bool> _requestCameraPermission() async {
        if (kIsWeb) return true;
        return (await Permission.camera.request()).isGranted;
    }

    Future<void> _applySettings() async {
        if (_cameraController == null) return;

        try {
            await _cameraController!.setFocusMode(FocusMode.auto);
            if (!kIsWeb) {
                try {
                    await _cameraController!.setFlashMode(FlashMode.auto);
                } catch (e) {
                    debugPrint('Flash mode not supported: $e');
                }
            }
        } catch (e) {
            debugPrint('Camera settings error: $e');
        }
    }

    Future<void> _handleImageSelection() async {
        showModalBottomSheet(
            context: context,
            builder: (context) => Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Text(
                            'Update Profile Photo',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                            ),
                        ),
                        SizedBox(height: 2.h),
                        ListTile(
                            leading: CustomIconWidget(
                                iconName: 'camera_alt',
                                size: 6.w,
                                color: Theme.of(context).colorScheme.primary,
                            ),
                            title: const Text('Take Photo'),
                            onTap: () {
                                Navigator.pop(context);
                                _capturePhoto();
                            },
                        ),
                        ListTile(
                            leading: CustomIconWidget(
                                iconName: 'photo_library',
                                size: 6.w,
                                color: Theme.of(context).colorScheme.primary,
                            ),
                            title: const Text('Choose from Gallery'),
                            onTap: () {
                                Navigator.pop(context);
                                _pickImageFromGallery();
                            },
                        ),
                    ],
                ),
            ),
        );
    }

    Future<void> _capturePhoto() async {
        if (_cameraController == null || !_isCameraInitialized) {
            await _initializeCamera();
        }

        if (_cameraController != null && _isCameraInitialized) {
            try {
                final XFile photo = await _cameraController!.takePicture();
                setState(() {
                    _capturedImage = photo;
                    _profileData['profileImage'] = photo.path;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('Profile photo updated successfully'),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                );
            } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('Failed to capture photo'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                );
            }
        }
    }

    Future<void> _pickImageFromGallery() async {
        try {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.gallery);

            if (image != null) {
                setState(() {
                    _capturedImage = image;
                    _profileData['profileImage'] = image.path;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('Profile photo updated successfully'),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                );
            }
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text('Failed to select photo'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                ),
            );
        }
    }

    // Save methods for each section
    Future<void> _saveBio() async {
        setState(() => _loadingStates['bio'] = true);

        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        setState(() => _loadingStates['bio'] = false);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Bio updated successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
        );
    }

    Future<void> _saveSkills() async {
        setState(() => _loadingStates['skills'] = true);

        await Future.delayed(const Duration(seconds: 1));

        setState(() => _loadingStates['skills'] = false);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Skills updated successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
        );
    }

    Future<void> _saveLanguages() async {
        setState(() => _loadingStates['languages'] = true);

        await Future.delayed(const Duration(seconds: 1));

        setState(() => _loadingStates['languages'] = false);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Languages updated successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
        );
    }

    Future<void> _savePricing() async {
        setState(() => _loadingStates['pricing'] = true);

        await Future.delayed(const Duration(seconds: 1));

        setState(() => _loadingStates['pricing'] = false);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Pricing updated successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
        );
    }

    Future<void> _saveExperience() async {
        setState(() => _loadingStates['experience'] = true);

        await Future.delayed(const Duration(seconds: 1));

        setState(() => _loadingStates['experience'] = false);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Experience updated successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
        );
    }

    Future<void> _saveAvailability() async {
        setState(() => _loadingStates['availability'] = true);

        await Future.delayed(const Duration(seconds: 1));

        setState(() => _loadingStates['availability'] = false);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Availability updated successfully'),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
        );
    }

    // Calculate profile completion percentage
    double _calculateCompletionPercentage() {
        double completion = 0.0;

        // Profile image (10%)
        if (_profileData['profileImage'] != null &&
            _profileData['profileImage'].isNotEmpty) {
            completion += 10.0;
        }

        // Bio (15%)
        if (_profileData['bio'] != null &&
            (_profileData['bio'] as String).length > 50) {
            completion += 15.0;
        }

        // Skills (15%)
        if ((_profileData['selectedSkills'] as List).length >= 3) {
            completion += 15.0;
        }

        // Languages (10%)
        if ((_profileData['selectedLanguages'] as List).isNotEmpty) {
            completion += 10.0;
        }

        // Pricing (20%)
        final pricing = _profileData['pricing'] as Map<String, double>;
        if (pricing.values.every((price) => price > 0)) {
            completion += 20.0;
        }

        // Experience (15%)
        if (_profileData['yearsOfExperience'] > 0) {
            completion += 15.0;
        }

        // Availability (15%)
        final schedule =
        _profileData['weeklySchedule'] as Map<String, List<String>>;
        if (schedule.values.any((slots) => slots.isNotEmpty)) {
            completion += 15.0;
        }

        return completion;
    }

    // Get missing fields for profile completion
    List<String> _getMissingFields() {
        List<String> missing = [];

        if (_profileData['profileImage'] == null ||
            _profileData['profileImage'].isEmpty) {
            missing.add('Profile Photo');
        }

        if (_profileData['bio'] == null ||
            (_profileData['bio'] as String).length <= 50) {
            missing.add('Professional Bio');
        }

        if ((_profileData['selectedSkills'] as List).length < 3) {
            missing.add('Skills (minimum 3)');
        }

        if ((_profileData['selectedLanguages'] as List).isEmpty) {
            missing.add('Languages');
        }

        final pricing = _profileData['pricing'] as Map<String, double>;
        if (!pricing.values.every((price) => price > 0)) {
            missing.add('Pricing Configuration');
        }

        if (_profileData['yearsOfExperience'] == 0) {
            missing.add('Years of Experience');
        }

        final schedule =
        _profileData['weeklySchedule'] as Map<String, List<String>>;
        if (!schedule.values.any((slots) => slots.isNotEmpty)) {
            missing.add('Weekly Schedule');
        }

        return missing;
    }

    void _viewAsClient() {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text('Client View'),
                content: const Text(
                    'This feature will show how your profile appears to clients. Coming soon!'),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        final completionPercentage = _calculateCompletionPercentage();
        final missingFields = _getMissingFields();

        return Scaffold(
            appBar: const CustomAppBar.standard(
                title: 'Profile Management',
            ),
            body: Column(
                children: [
                    // Profile Completion Widget
                    Padding(
                        padding: EdgeInsets.all(4.w),
                        child: ProfileCompletionWidget(
                            completionPercentage: completionPercentage,
                            missingFields: missingFields,
                            onViewAsClient: _viewAsClient,
                        ),
                    ),

                    // Tab Bar
                    Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            tabs: const [
                                Tab(text: 'Profile'),
                                Tab(text: 'Bio'),
                                Tab(text: 'Skills'),
                                Tab(text: 'Languages'),
                                Tab(text: 'Pricing'),
                                Tab(text: 'Experience'),
                            ],
                        ),
                    ),

                    // Tab Bar View
                    Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            children: [
                                // Profile Tab
                                SingleChildScrollView(
                                    controller: _scrollController,
                                    padding: EdgeInsets.all(4.w),
                                    child: Column(
                                        children: [
                                            ProfileHeaderWidget(
                                                profileImageUrl: _profileData['profileImage'],
                                                name: _profileData['name'],
                                                isVerified: _profileData['isVerified'],
                                                onImageTap: _handleImageSelection,
                                            ),
                                            SizedBox(height: 2.h),
                                            AvailabilitySectionWidget(
                                                weeklySchedule: Map<String, List<String>>.from(
                                                    _profileData['weeklySchedule']),
                                                holidays: List<DateTime>.from(_profileData['holidays']),
                                                onScheduleChanged: (schedule) {
                                                    setState(() {
                                                        _profileData['weeklySchedule'] = schedule;
                                                    });
                                                },
                                                onHolidaysChanged: (holidays) {
                                                    setState(() {
                                                        _profileData['holidays'] = holidays;
                                                    });
                                                },
                                                onSave: _saveAvailability,
                                                isLoading: _loadingStates['availability'] ?? false,
                                            ),
                                        ],
                                    ),
                                ),

                                // Bio Tab
                                SingleChildScrollView(
                                    padding: EdgeInsets.all(4.w),
                                    child: BioSectionWidget(
                                        bio: _profileData['bio'],
                                        onBioChanged: (bio) {
                                            setState(() {
                                                _profileData['bio'] = bio;
                                            });
                                        },
                                        onSave: _saveBio,
                                        isLoading: _loadingStates['bio'] ?? false,
                                    ),
                                ),

                                // Skills Tab
                                SingleChildScrollView(
                                    padding: EdgeInsets.all(4.w),
                                    child: SkillsSectionWidget(
                                        selectedSkills:
                                        List<String>.from(_profileData['selectedSkills']),
                                        onSkillsChanged: (skills) {
                                            setState(() {
                                                _profileData['selectedSkills'] = skills;
                                            });
                                        },
                                        onSave: _saveSkills,
                                        isLoading: _loadingStates['skills'] ?? false,
                                    ),
                                ),

                                // Languages Tab
                                SingleChildScrollView(
                                    padding: EdgeInsets.all(4.w),
                                    child: LanguagesSectionWidget(
                                        selectedLanguages:
                                        List<String>.from(_profileData['selectedLanguages']),
                                        onLanguagesChanged: (languages) {
                                            setState(() {
                                                _profileData['selectedLanguages'] = languages;
                                            });
                                        },
                                        onSave: _saveLanguages,
                                        isLoading: _loadingStates['languages'] ?? false,
                                    ),
                                ),

                                // Pricing Tab
                                SingleChildScrollView(
                                    padding: EdgeInsets.all(4.w),
                                    child: PricingSectionWidget(
                                        pricing: Map<String, double>.from(_profileData['pricing']),
                                        onPricingChanged: (pricing) {
                                            setState(() {
                                                _profileData['pricing'] = pricing;
                                            });
                                        },
                                        onSave: _savePricing,
                                        isLoading: _loadingStates['pricing'] ?? false,
                                    ),
                                ),

                                // Experience Tab
                                SingleChildScrollView(
                                    padding: EdgeInsets.all(4.w),
                                    child: ExperienceSectionWidget(
                                        yearsOfExperience: _profileData['yearsOfExperience'],
                                        certifications:
                                        List<String>.from(_profileData['certifications']),
                                        onExperienceChanged: (years) {
                                            setState(() {
                                                _profileData['yearsOfExperience'] = years;
                                            });
                                        },
                                        onCertificationsChanged: (certifications) {
                                            setState(() {
                                                _profileData['certifications'] = certifications;
                                            });
                                        },
                                        onSave: _saveExperience,
                                        isLoading: _loadingStates['experience'] ?? false,
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
            bottomNavigationBar: CustomBottomBar.standard(
                currentIndex: _currentBottomNavIndex,
                onTap: (index) {
                    setState(() {
                        _currentBottomNavIndex = index;
                    });
                },
            ),
        );
    }
}
