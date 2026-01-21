import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/quick_responses_widget.dart';
import './widgets/session_controls_widget.dart';
import './widgets/typing_indicator_widget.dart';

class ChatInterfaceScreen extends StatefulWidget {
    final String roomId;
    final String sessionId;
    final Map<String, dynamic> clientData;

    const ChatInterfaceScreen({
        Key? key,
        required this.roomId,
        required this.sessionId,
        required this.clientData,
    }) : super(key: key);

    @override
    State<ChatInterfaceScreen> createState() => _ChatInterfaceScreenState();
}

class _ChatInterfaceScreenState extends State<ChatInterfaceScreen> {
    final ScrollController _scrollController = ScrollController();
    Timer? _sessionTimer;
    Timer? _typingTimer;

    // Session state
    Duration _sessionDuration = Duration.zero;
    double _currentEarnings = 0.0;
    bool _isSessionActive = true;
    bool _isSessionPaused = false;
    bool _showQuickResponses = false;
    bool _isClientTyping = false;

    // Chat state
    final List<Map<String, dynamic>> _messages = [];

    // Mock client data
    final Map<String, dynamic> _clientData = {
        'name': 'Sarah Johnson',
        'avatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_14da91c34-1763294780479.png',
        'semanticLabel':
        'Professional headshot of a woman with shoulder-length brown hair wearing a navy blue blazer',
        'sessionType': 'Chat Consultation',
        'ratePerMinute': 2.50,
    };

    @override
    void initState() {
        super.initState();
        _initializeChat();
        _startSessionTimer();
        _simulateClientTyping();
    }

    @override
    void dispose() {
        _sessionTimer?.cancel();
        _typingTimer?.cancel();
        _scrollController.dispose();
        super.dispose();
    }

    void _initializeChat() {
        // Initialize with welcome message
        _messages.addAll([
            {
                'id': '1',
                'content':
                'Hello! I\'m here for my astrology consultation. I\'m excited to learn about my birth chart and what the stars have to say about my future.',
                'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
                'isAstrologer': false,
                'type': 'text',
                'isRead': true,
            },
            {
                'id': '2',
                'content':
                'Welcome, Sarah! I\'m delighted to guide you through your astrological journey today. Let\'s start by exploring your birth chart and the cosmic influences shaping your path.',
                'timestamp': DateTime.now().subtract(const Duration(minutes: 1)),
                'isAstrologer': true,
                'type': 'text',
                'isRead': true,
            },
        ]);
    }

    void _startSessionTimer() {
        _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (_isSessionActive && !_isSessionPaused) {
                setState(() {
                    _sessionDuration = Duration(seconds: _sessionDuration.inSeconds + 1);
                    _currentEarnings =
                        (_sessionDuration.inMinutes * (_clientData['ratePerMinute'] as double)) +
                            ((_sessionDuration.inSeconds % 60) *
                                ((_clientData['ratePerMinute'] as double) / 60));
                });
            }
        });
    }

    void _simulateClientTyping() {
        Timer.periodic(const Duration(seconds: 15), (timer) {
            if (_isSessionActive && mounted) {
                setState(() {
                    _isClientTyping = true;
                });

                Timer(const Duration(seconds: 3), () {
                    if (mounted) {
                        setState(() {
                            _isClientTyping = false;
                        });
                    }
                });
            } else {
                timer.cancel();
            }
        });
    }

    void _sendMessage(String content) {
        if (content.trim().isEmpty || !_isSessionActive) return;

        final message = {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'timestamp': DateTime.now(),
            'isAstrologer': true,
            'type': 'text',
            'isRead': false,
        };

        setState(() {
            _messages.add(message);
            _showQuickResponses = false;
        });

        _scrollToBottom();
        _markMessageAsRead(message['id'] as String);
    }

    void _sendFile(String fileName, String fileSize) {
        if (!_isSessionActive) return;

        final message = {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': 'Document shared',
            'timestamp': DateTime.now(),
            'isAstrologer': true,
            'type': 'file',
            'fileName': fileName,
            'fileSize': fileSize,
            'isRead': false,
        };

        setState(() {
            _messages.add(message);
        });

        _scrollToBottom();
        _markMessageAsRead(message['id'] as String);
    }

    void _sendImage(String imagePath, String semanticLabel) {
        if (!_isSessionActive) return;

        final message = {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': 'Image shared',
            'timestamp': DateTime.now(),
            'isAstrologer': true,
            'type': 'image',
            'imageUrl':
            'https://images.pexels.com/photos/1252890/pexels-photo-1252890.jpeg?auto=compress&cs=tinysrgb&w=400',
            'semanticLabel': semanticLabel,
            'isRead': false,
        };

        setState(() {
            _messages.add(message);
        });

        _scrollToBottom();
        _markMessageAsRead(message['id'] as String);
    }

    void _markMessageAsRead(String messageId) {
        Timer(const Duration(seconds: 2), () {
            if (mounted) {
                setState(() {
                    final messageIndex =
                    _messages.indexWhere((msg) => msg['id'] == messageId);
                    if (messageIndex != -1) {
                        _messages[messageIndex]['isRead'] = true;
                    }
                });
            }
        });
    }

    void _scrollToBottom() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                );
            }
        });
    }

    void _pauseResumeSession() {
        setState(() {
            _isSessionPaused = !_isSessionPaused;
        });
    }

    void _endSession() {
        setState(() {
            _isSessionActive = false;
            _isSessionPaused = false;
        });

        _sessionTimer?.cancel();

        // Show session summary and navigate to report editor
        _showSessionSummary();
    }

    void _showSessionSummary() {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                title: Row(
                    children: [
                        CustomIconWidget(
                            iconName: 'check_circle',
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 6.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                            'Session Completed',
                            style: Theme.of(context).textTheme.titleLarge,
                        ),
                    ],
                ),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Text(
                            'Your consultation session with ${_clientData['name']} has been completed successfully.',
                            style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.3),
                                    width: 1,
                                ),
                            ),
                            child: Column(
                                children: [
                                    _buildSummaryRow(
                                        'Duration', _formatDuration(_sessionDuration)),
                                    SizedBox(height: 1.h),
                                    _buildSummaryRow(
                                        'Earnings', '\$${_currentEarnings.toStringAsFixed(2)}'),
                                    SizedBox(height: 1.h),
                                    _buildSummaryRow('Messages', '${_messages.length}'),
                                ],
                            ),
                        ),
                    ],
                ),
                actions: [
                    TextButton(
                        onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, '/dashboard-screen');
                        },
                        child: Text(
                            'Dashboard',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/report-editor-screen');
                        },
                        child: Text(
                            'Create Report',
                            style: Theme.of(context).textTheme.labelLarge,
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildSummaryRow(String label, String value) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(
                    '$label:',
                    style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                    ),
                ),
            ],
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
        final theme = Theme.of(context);

        return Scaffold(
            appBar: AppBar(
                title: Row(
                    children: [
                        CircleAvatar(
                            radius: 4.w,
                            child: CustomImageWidget(
                                imageUrl: _clientData['avatar'],
                                width: 8.w,
                                height: 8.w,
                                fit: BoxFit.cover,
                                semanticLabel: _clientData['semanticLabel'],
                            ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        _clientData['name'],
                                        style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                        children: [
                                            Container(
                                                width: 2.w,
                                                height: 2.w,
                                                decoration: BoxDecoration(
                                                    color: _isSessionActive && !_isSessionPaused
                                                        ? theme.colorScheme.tertiary
                                                        : theme.colorScheme.error,
                                                    shape: BoxShape.circle,
                                                ),
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                                _isSessionActive
                                                    ? (_isSessionPaused ? 'Paused' : 'Active')
                                                    : 'Ended',
                                                style: theme.textTheme.labelSmall?.copyWith(
                                                    color: theme.colorScheme.onSurfaceVariant,
                                                ),
                                            ),
                                            SizedBox(width: 2.w),
                                            Text(
                                                '• ${_formatDuration(_sessionDuration)}',
                                                style: theme.textTheme.labelSmall?.copyWith(
                                                    color: theme.colorScheme.onSurfaceVariant,
                                                ),
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
                actions: [
                    IconButton(
                        onPressed: () => setState(() {
                            _showQuickResponses = !_showQuickResponses;
                        }),
                        icon: CustomIconWidget(
                            iconName: _showQuickResponses ? 'keyboard_hide' : 'flash_on',
                            color: _showQuickResponses
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 6.w,
                        ),
                    ),
                    PopupMenuButton<String>(
                        onSelected: (value) {
                            switch (value) {
                                case 'audio':
                                    Navigator.pushNamed(context, '/audio-call-screen');
                                    break;
                                case 'video':
                                    Navigator.pushNamed(context, '/video-call-screen');
                                    break;
                                case 'report':
                                    Navigator.pushNamed(context, '/report-editor-screen');
                                    break;
                            }
                        },
                        itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 'audio',
                                child: Row(
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'call',
                                            color: theme.colorScheme.onSurface,
                                            size: 5.w,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text('Switch to Audio Call'),
                                    ],
                                ),
                            ),
                            PopupMenuItem(
                                value: 'video',
                                child: Row(
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'videocam',
                                            color: theme.colorScheme.onSurface,
                                            size: 5.w,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text('Switch to Video Call'),
                                    ],
                                ),
                            ),
                            PopupMenuItem(
                                value: 'report',
                                child: Row(
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'description',
                                            color: theme.colorScheme.onSurface,
                                            size: 5.w,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text('Create Report'),
                                    ],
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            body: Column(
                children: [
                    // Session Controls
                    SessionControlsWidget(
                        sessionDuration: _sessionDuration,
                        currentEarnings: _currentEarnings,
                        isSessionActive: _isSessionActive,
                        isSessionPaused: _isSessionPaused,
                        onPauseResume: _pauseResumeSession,
                        onEndSession: _endSession,
                    ),

                    // Messages Area
                    Expanded(
                        child: Container(
                            color: theme.colorScheme.surface.withValues(alpha: 0.5),
                            child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                    final message = _messages[index];
                                    return MessageBubbleWidget(
                                        message: message,
                                        isAstrologer: message['isAstrologer'] as bool,
                                    );
                                },
                            ),
                        ),
                    ),

                    // Typing Indicator
                    TypingIndicatorWidget(
                        isVisible: _isClientTyping,
                        userName: _clientData['name'],
                    ),

                    // Quick Responses
                    QuickResponsesWidget(
                        onQuickResponse: _sendMessage,
                        isVisible: _showQuickResponses,
                    ),

                    // Message Input
                    MessageInputWidget(
                        onSendMessage: _sendMessage,
                        onSendFile: _sendFile,
                        onSendImage: _sendImage,
                        isSessionActive: _isSessionActive,
                    ),
                ],
            ),
        );
    }
}