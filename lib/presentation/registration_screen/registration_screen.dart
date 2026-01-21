import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/password_section.dart';
import './widgets/personal_info_section.dart';
import './widgets/specialization_section.dart';
import './widgets/step_indicator.dart';
import './widgets/terms_agreement_section.dart';

class RegistrationScreen extends StatefulWidget {
    const RegistrationScreen({super.key});

    @override
    State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
    final PageController _pageController = PageController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // Controllers
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
    TextEditingController();

    // State variables
    int _currentStep = 0;
    final int _totalSteps = 4;
    List<String> _selectedSpecializations = [];
    bool _isTermsAgreed = false;
    bool _isLoading = false;

    // Validation errors
    String? _nameError;
    String? _emailError;
    String? _phoneError;
    String? _passwordError;
    String? _confirmPasswordError;

    @override
    void dispose() {
        _pageController.dispose();
        _nameController.dispose();
        _emailController.dispose();
        _phoneController.dispose();
        _passwordController.dispose();
        _confirmPasswordController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: _currentStep > 0
                    ? IconButton(
                    icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        size: 24,
                        color: theme.colorScheme.onSurface,
                    ),
                    onPressed: _previousStep,
                )
                    : IconButton(
                    icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        size: 24,
                        color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                    'Create Account',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                    ),
                ),
                centerTitle: true,
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login-screen'),
                        child: Text(
                            'Login',
                            style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                            ),
                        ),
                    ),
                ],
            ),
            body: SafeArea(
                child: Column(
                    children: [
                        // Step Indicator
                        StepIndicator(
                            currentStep: _currentStep,
                            totalSteps: _totalSteps,
                        ),

                        // Form Content
                        Expanded(
                            child: Form(
                                key: _formKey,
                                child: PageView(
                                    controller: _pageController,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                        _buildPersonalInfoStep(),
                                        _buildSpecializationStep(),
                                        _buildPasswordStep(),
                                        _buildTermsStep(),
                                    ],
                                ),
                            ),
                        ),

                        // Bottom Action Button
                        _buildBottomActionButton(),
                    ],
                ),
            ),
        );
    }

    Widget _buildPersonalInfoStep() {
        return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Personal Information',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                        'Tell us about yourself to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    ),
                    SizedBox(height: 3.h),
                    PersonalInfoSection(
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        nameError: _nameError,
                        emailError: _emailError,
                        phoneError: _phoneError,
                        onNameChanged: _clearNameError,
                        onEmailChanged: _clearEmailError,
                        onPhoneChanged: _clearPhoneError,
                    ),
                    SizedBox(height: 10.h),
                ],
            ),
        );
    }

    Widget _buildSpecializationStep() {
        return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Professional Details',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                        'Select your areas of expertise',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    ),
                    SizedBox(height: 3.h),
                    SpecializationSection(
                        selectedSpecializations: _selectedSpecializations,
                        onSpecializationToggle: _toggleSpecialization,
                    ),
                    SizedBox(height: 10.h),
                ],
            ),
        );
    }

    Widget _buildPasswordStep() {
        return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Account Security',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                        'Create a secure password for your account',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    ),
                    SizedBox(height: 3.h),
                    PasswordSection(
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        passwordError: _passwordError,
                        confirmPasswordError: _confirmPasswordError,
                        onPasswordChanged: _clearPasswordError,
                        onConfirmPasswordChanged: _clearConfirmPasswordError,
                    ),
                    SizedBox(height: 10.h),
                ],
            ),
        );
    }

    Widget _buildTermsStep() {
        return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Almost Done!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                        'Please review and accept our terms',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    ),
                    SizedBox(height: 3.h),
                    TermsAgreementSection(
                        isAgreed: _isTermsAgreed,
                        onAgreementChanged: (value) =>
                            setState(() => _isTermsAgreed = value),
                    ),
                    SizedBox(height: 10.h),
                ],
            ),
        );
    }

    Widget _buildBottomActionButton() {
        final theme = Theme.of(context);
        final isLastStep = _currentStep == _totalSteps - 1;
        final canProceed = _canProceedToNextStep();

        return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                    BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                    ),
                ],
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    if (isLastStep && !_isTermsAgreed)
                        Container(
                            padding: EdgeInsets.all(3.w),
                            margin: EdgeInsets.only(bottom: 2.h),
                            decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                                    width: 1,
                                ),
                            ),
                            child: Row(
                                children: [
                                    CustomIconWidget(
                                        iconName: 'warning',
                                        size: 16,
                                        color: theme.colorScheme.error,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                        child: Text(
                                            'Please accept the terms and conditions to continue',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.error,
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                            onPressed: canProceed && !_isLoading
                                ? (isLastStep ? _createAccount : _nextStep)
                                : null,
                            child: _isLoading
                                ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.onPrimary,
                                    ),
                                ),
                            )
                                : Text(
                                isLastStep ? 'Create Account' : 'Continue',
                                style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                ),
                            ),
                        ),
                    ),
                    if (!isLastStep) ...[
                        SizedBox(height: 2.h),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                    'Already have an account? ',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                ),
                                GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, '/login-screen'),
                                    child: Text(
                                        'Login',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ],
                ],
            ),
        );
    }

    bool _canProceedToNextStep() {
        switch (_currentStep) {
            case 0:
                return _nameController.text.trim().isNotEmpty &&
                    _emailController.text.trim().isNotEmpty &&
                    _phoneController.text.trim().isNotEmpty &&
                    _nameError == null &&
                    _emailError == null &&
                    _phoneError == null;
            case 1:
                return _selectedSpecializations.isNotEmpty;
            case 2:
                return _passwordController.text.isNotEmpty &&
                    _confirmPasswordController.text.isNotEmpty &&
                    _passwordError == null &&
                    _confirmPasswordError == null;
            case 3:
                return _isTermsAgreed;
            default:
                return false;
        }
    }

    void _nextStep() {
        if (_validateCurrentStep()) {
            setState(() => _currentStep++);
            _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
            );
        }
    }

    void _previousStep() {
        if (_currentStep > 0) {
            setState(() => _currentStep--);
            _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
            );
        }
    }

    bool _validateCurrentStep() {
        switch (_currentStep) {
            case 0:
                return _validatePersonalInfo();
            case 1:
                return _validateSpecializations();
            case 2:
                return _validatePasswords();
            case 3:
                return _isTermsAgreed;
            default:
                return false;
        }
    }

    bool _validatePersonalInfo() {
        bool isValid = true;

        // Name validation
        if (_nameController.text.trim().isEmpty) {
            setState(() => _nameError = 'Full name is required');
            isValid = false;
        } else if (_nameController.text.trim().length < 2) {
            setState(() => _nameError = 'Name must be at least 2 characters');
            isValid = false;
        }

        // Email validation
        if (_emailController.text.trim().isEmpty) {
            setState(() => _emailError = 'Email address is required');
            isValid = false;
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailController.text.trim())) {
            setState(() => _emailError = 'Please enter a valid email address');
            isValid = false;
        }

        // Phone validation
        if (_phoneController.text.trim().isEmpty) {
            setState(() => _phoneError = 'Phone number is required');
            isValid = false;
        } else if (_phoneController.text.trim().length < 10) {
            setState(() => _phoneError = 'Please enter a valid phone number');
            isValid = false;
        }

        return isValid;
    }

    bool _validateSpecializations() {
        return _selectedSpecializations.isNotEmpty;
    }

    bool _validatePasswords() {
        bool isValid = true;

        // Password validation
        if (_passwordController.text.isEmpty) {
            setState(() => _passwordError = 'Password is required');
            isValid = false;
        } else if (_passwordController.text.length < 8) {
            setState(() => _passwordError = 'Password must be at least 8 characters');
            isValid = false;
        } else if (!_isPasswordStrong(_passwordController.text)) {
            setState(() => _passwordError =
            'Password must contain uppercase, lowercase, number and special character');
            isValid = false;
        }

        // Confirm password validation
        if (_confirmPasswordController.text.isEmpty) {
            setState(() => _confirmPasswordError = 'Please confirm your password');
            isValid = false;
        } else if (_passwordController.text != _confirmPasswordController.text) {
            setState(() => _confirmPasswordError = 'Passwords do not match');
            isValid = false;
        }

        return isValid;
    }

    bool _isPasswordStrong(String password) {
        return password.contains(RegExp(r'[A-Z]')) &&
            password.contains(RegExp(r'[a-z]')) &&
            password.contains(RegExp(r'[0-9]')) &&
            password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    }

    void _toggleSpecialization(String specialization) {
        setState(() {
            if (_selectedSpecializations.contains(specialization)) {
                _selectedSpecializations.remove(specialization);
            } else {
                _selectedSpecializations.add(specialization);
            }
        });
    }

    void _clearNameError() => setState(() => _nameError = null);
    void _clearEmailError() => setState(() => _emailError = null);
    void _clearPhoneError() => setState(() => _phoneError = null);
    void _clearPasswordError() => setState(() => _passwordError = null);
    void _clearConfirmPasswordError() =>
        setState(() => _confirmPasswordError = null);

    Future<void> _createAccount() async {
        if (!_validateCurrentStep()) return;

        setState(() => _isLoading = true);

        try {
            // Simulate account creation process
            await Future.delayed(const Duration(seconds: 2));

            // Show success message
            if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Row(
                            children: [
                                CustomIconWidget(
                                    iconName: 'check_circle',
                                    size: 20,
                                    color: Colors.white,
                                ),
                                SizedBox(width: 2.w),
                                const Expanded(
                                    child: Text(
                                        'Account created successfully! Please verify your email.'),
                                ),
                            ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        behavior: SnackBarBehavior.floating,
                    ),
                );

                // Navigate to KYC verification
                Navigator.pushReplacementNamed(context, '/kyc-verification-screen');
            }
        } catch (e) {
            if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Row(
                            children: [
                                CustomIconWidget(
                                    iconName: 'error',
                                    size: 20,
                                    color: Colors.white,
                                ),
                                SizedBox(width: 2.w),
                                const Expanded(
                                    child: Text('Failed to create account. Please try again.'),
                                ),
                            ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                    ),
                );
            }
        } finally {
            if (mounted) {
                setState(() => _isLoading = false);
            }
        }
    }
}
