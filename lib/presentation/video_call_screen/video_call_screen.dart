import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import './widgets/connection_quality_indicator.dart';
import './widgets/notes_panel.dart';
import './widgets/session_info_panel.dart';
import './widgets/video_controls_overlay.dart';
import './widgets/video_feed_widget.dart';

/// Video Call Screen for face-to-face astrology consultations
/// Provides professional video interface with session management
class VideoCallScreen extends StatefulWidget {
    const VideoCallScreen({super.key});

    @override
    State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
    // Camera and video state
    CameraController? _cameraController;
    List<CameraDescription> _cameras = [];
    bool _isCameraInitialized = false;
    bool _isCameraOn = true;
    bool _isFrontCamera = true;

    // Audio state
    bool _isMuted = false;
    bool _isSpeakerOn = true;

    // UI state
    bool _areControlsVisible = true;
    bool _isSessionInfoVisible = false;
    bool _isNotesVisible = false;
    bool _isConnectionQualityVisible = false;

    // Session data
    late DateTime _sessionStartTime;
    Duration _sessionDuration = const Duration(minutes: 30);
    Duration _elapsedTime = Duration.zero;
    String _consultationNotes = '';
    ConnectionQuality _connectionQuality = ConnectionQuality.good;

    // Animation controllers
    late AnimationController _headerAnimationController;
    late AnimationController _pipAnimationController;
    late Animation<Offset> _pipAnimation;

    // Timers and other controllers
    late Stream<Duration> _timerStream;
    bool _isSessionPaused = false;

    // Mock session data
    final Map<String, dynamic> _sessionData = {
        "sessionId": "VS_2025_001847",
        "clientName": "Sarah Johnson",
        "clientAvatar":
        "https://images.unsplash.com/photo-1734750211424-e09445180d9a",
        "consultationType": "Vedic Astrology Reading",
        "ratePerMinute": 3.50,
        "agreedDuration": 30,
        "sessionStartTime": "2025-11-18T09:20:42.752432",
    };

    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addObserver(this);
        _initializeSession();
        _initializeAnimations();
        _initializeCamera();
        _startSessionTimer();

        // Lock orientation to portrait
        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
        ]);

        // Hide system UI for immersive experience
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }

    @override
    void dispose() {
        WidgetsBinding.instance.removeObserver(this);
        _cameraController?.dispose();
        _headerAnimationController.dispose();
        _pipAnimationController.dispose();

        // Restore system UI and orientation
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);

        super.dispose();
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
        super.didChangeAppLifecycleState(state);

        if (_cameraController == null || !_cameraController!.value.isInitialized) {
            return;
        }

        if (state == AppLifecycleState.inactive) {
            _cameraController?.dispose();
        } else if (state == AppLifecycleState.resumed) {
            _initializeCamera();
        }
    }

    void _initializeSession() {
        _sessionStartTime = DateTime.parse(_sessionData["sessionStartTime"]);
        _sessionDuration = Duration(minutes: _sessionData["agreedDuration"]);
    }

    void _initializeAnimations() {
        _headerAnimationController = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
        );

        _pipAnimationController = AnimationController(
            duration: const Duration(milliseconds: 200),
            vsync: this,
        );

        _pipAnimation = Tween<Offset>(
            begin: const Offset(0.65, 0.1),
            end: const Offset(0.65, 0.1),
        ).animate(CurvedAnimation(
            parent: _pipAnimationController,
            curve: Curves.easeInOut,
        ));
    }

    Future<void> _initializeCamera() async {
        try {
            // Request camera permission
            final cameraPermission = await Permission.camera.request();
            final microphonePermission = await Permission.microphone.request();

            if (!cameraPermission.isGranted || !microphonePermission.isGranted) {
                _showPermissionDialog();
                return;
            }

            // Get available cameras
            _cameras = await availableCameras();
            if (_cameras.isEmpty) return;

            // Initialize camera controller
            final camera = _cameras.firstWhere(
                    (camera) => camera.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras.first,
            );

            _cameraController = CameraController(
                camera,
                ResolutionPreset.high,
                enableAudio: true,
            );

            await _cameraController!.initialize();

            if (mounted) {
                setState(() {
                    _isCameraInitialized = true;
                });
            }
        } catch (e) {
            debugPrint('Camera initialization error: $e');
            if (mounted) {
                _showCameraErrorDialog();
            }
        }
    }

    void _startSessionTimer() {
        _timerStream = Stream.periodic(const Duration(seconds: 1), (count) {
            if (!_isSessionPaused) {
                return Duration(seconds: count);
            }
            return _elapsedTime;
        });
    }

    void _toggleControlsVisibility() {
        setState(() {
            _areControlsVisible = !_areControlsVisible;
        });

        if (_areControlsVisible) {
            _headerAnimationController.forward();
        } else {
            _headerAnimationController.reverse();
        }
    }

    void _toggleMute() {
        setState(() {
            _isMuted = !_isMuted;
        });
        // TODO: Implement actual audio muting
        HapticFeedback.lightImpact();
    }

    void _toggleCamera() {
        setState(() {
            _isCameraOn = !_isCameraOn;
        });
        // TODO: Implement actual camera toggle
        HapticFeedback.lightImpact();
    }

    void _toggleSpeaker() {
        setState(() {
            _isSpeakerOn = !_isSpeakerOn;
        });
        // TODO: Implement actual speaker toggle
        HapticFeedback.lightImpact();
    }

    Future<void> _flipCamera() async {
        if (_cameras.length < 2) return;

        try {
            final newCamera = _cameras.firstWhere(
                    (camera) =>
                camera.lensDirection ==
                    (_isFrontCamera
                        ? CameraLensDirection.back
                        : CameraLensDirection.front),
                orElse: () => _cameras.first,
            );

            await _cameraController?.dispose();
            _cameraController = CameraController(
                newCamera,
                ResolutionPreset.high,
                enableAudio: true,
            );

            await _cameraController!.initialize();

            setState(() {
                _isFrontCamera = !_isFrontCamera;
            });

            HapticFeedback.lightImpact();
        } catch (e) {
            debugPrint('Camera flip error: $e');
        }
    }

    void _endCall() {
        _showEndCallDialog();
    }

    void _showEndCallDialog() {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                        'End Consultation',
                        style: Theme.of(context).textTheme.titleLarge,
                    ),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                'Are you sure you want to end this consultation?',
                                style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 2.h),
                            Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            'Session Summary:',
                                            style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                            'Duration: ${_formatDuration(_elapsedTime)}',
                                            style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        Text(
                                            'Earnings: \$${(_elapsedTime.inMinutes * _sessionData["ratePerMinute"]).toStringAsFixed(2)}',
                                            style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    ),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                                'Continue Session',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 14.sp,
                                ),
                            ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                                _completeSession();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                            ),
                            child: Text(
                                'End Session',
                                style: TextStyle(fontSize: 14.sp),
                            ),
                        ),
                    ],
                );
            },
        );
    }

    void _completeSession() {
        // Navigate to rating/feedback screen or dashboard
        Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard-screen',
                (route) => false,
        );
    }

    void _showPermissionDialog() {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Permissions Required'),
                    content: const Text(
                        'Camera and microphone permissions are required for video consultations. Please grant permissions in settings.',
                    ),
                    actions: [
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacementNamed(context, '/dashboard-screen');
                            },
                            child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                                openAppSettings();
                            },
                            child: const Text('Open Settings'),
                        ),
                    ],
                );
            },
        );
    }

    void _showCameraErrorDialog() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Camera Error'),
                    content: const Text(
                        'Unable to initialize camera. Please check if camera is being used by another app.',
                    ),
                    actions: [
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                                _initializeCamera();
                            },
                            child: const Text('Retry'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacementNamed(context, '/dashboard-screen');
                            },
                            child: const Text('Exit'),
                        ),
                    ],
                );
            },
        );
    }

    String _formatDuration(Duration duration) {
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child: Stack(
                    children: [
                        // Main client video feed
                        _buildMainVideoFeed(),

                        // Astrologer's self-view (Picture-in-Picture)
                        _buildPictureInPicture(),

                        // Session header with client info and timer
                        _buildSessionHeader(),

                        // Video controls overlay
                        VideoControlsOverlay(
                            isVisible: _areControlsVisible,
                            isMuted: _isMuted,
                            isCameraOn: _isCameraOn,
                            isSpeakerOn: _isSpeakerOn,
                            isFrontCamera: _isFrontCamera,
                            onToggleMute: _toggleMute,
                            onToggleCamera: _toggleCamera,
                            onToggleSpeaker: _toggleSpeaker,
                            onFlipCamera: _flipCamera,
                            onEndCall: _endCall,
                            onToggleVisibility: _toggleControlsVisibility,
                        ),

                        // Session info panel
                        if (_isSessionInfoVisible)
                            SessionInfoPanel(
                                isVisible: _isSessionInfoVisible,
                                clientName: _sessionData["clientName"],
                                consultationType: _sessionData["consultationType"],
                                sessionDuration: _sessionDuration,
                                elapsedTime: _elapsedTime,
                                ratePerMinute: _sessionData["ratePerMinute"],
                                sessionId: _sessionData["sessionId"],
                                onClose: () => setState(() => _isSessionInfoVisible = false),
                            ),

                        // Notes panel
                        if (_isNotesVisible)
                            NotesPanel(
                                isVisible: _isNotesVisible,
                                initialNotes: _consultationNotes,
                                onNotesChanged: (notes) => _consultationNotes = notes,
                                onClose: () => setState(() => _isNotesVisible = false),
                                onSave: () {
                                    // TODO: Save notes to backend
                                },
                            ),

                        // Connection quality indicator
                        ConnectionQualityIndicator(
                            quality: _connectionQuality,
                            isVisible: _isConnectionQualityVisible,
                            onDismiss: () =>
                                setState(() => _isConnectionQualityVisible = false),
                        ),

                        // Edge swipe detector for session info
                        _buildEdgeSwipeDetector(),
                    ],
                ),
            ),
        );
    }

    Widget _buildMainVideoFeed() {
        return VideoFeedWidget(
            cameraController: null, // Client's video feed would come from WebRTC
            isMainFeed: true,
            placeholderText: 'Connecting to ${_sessionData["clientName"]}...',
            placeholderImageUrl: _sessionData["clientAvatar"],
            onTap: _toggleControlsVisibility,
        );
    }

    Widget _buildPictureInPicture() {
        return SlideTransition(
            position: _pipAnimation,
            child: Positioned(
                top: 15.h,
                right: 4.w,
                child: GestureDetector(
                    onPanUpdate: (details) {
                        // TODO: Implement draggable PiP functionality
                    },
                    child: Container(
                        width: 25.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                ),
                            ],
                        ),
                        child: VideoFeedWidget(
                            cameraController: _cameraController,
                            isMainFeed: false,
                            isVisible: _isCameraOn,
                            placeholderText: 'You',
                            onTap: _toggleControlsVisibility,
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _buildSessionHeader() {
        return AnimatedBuilder(
            animation: _headerAnimationController,
            builder: (context, child) {
                return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Transform.translate(
                        offset: Offset(0, -10.h * (1 - _headerAnimationController.value)),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Colors.black.withValues(alpha: 0.8),
                                        Colors.transparent,
                                    ],
                                ),
                            ),
                            child: StreamBuilder<Duration>(
                                stream: _timerStream,
                                builder: (context, snapshot) {
                                    if (snapshot.hasData && !_isSessionPaused) {
                                        _elapsedTime = snapshot.data!;
                                    }

                                    return Row(
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text(
                                                            _sessionData["clientName"],
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Text(
                                                            _sessionData["consultationType"],
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                color: Colors.white.withValues(alpha: 0.8),
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                    Text(
                                                        _formatDuration(_elapsedTime),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                        ),
                                                    ),
                                                    Text(
                                                        '\$${(_elapsedTime.inMinutes * _sessionData["ratePerMinute"]).toStringAsFixed(2)}',
                                                        style:
                                                        Theme.of(context).textTheme.bodySmall?.copyWith(
                                                            color: Colors.green,
                                                            fontWeight: FontWeight.w500,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ],
                                    );
                                },
                            ),
                        ),
                    ),
                );
            },
        );
    }

    Widget _buildEdgeSwipeDetector() {
        return Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
                onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                        setState(() => _isSessionInfoVisible = true);
                    }
                },
                child: Container(
                    width: 5.w,
                    color: Colors.transparent,
                ),
            ),
        );
    }
}
