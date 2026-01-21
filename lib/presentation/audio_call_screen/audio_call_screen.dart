  // lib/presentation/audio_call_screen/audio_call_screen.dart

  import 'dart:async';
  import 'package:agora_rtc_engine/agora_rtc_engine.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:sizer/sizer.dart';
  import 'package:permission_handler/permission_handler.dart';

  import '../../core/app_export.dart';
  import '../../services/agora_service.dart';
  import '../../services/api_client.dart';
  import '../../services/chat_socket_service.dart';
  import '../../services/config.dart';
  import '../../services/storage_service.dart';
  import './widgets/call_controls_widget.dart';
  import './widgets/client_avatar_widget.dart';
  import './widgets/notes_overlay_widget.dart';
  import './widgets/session_info_sheet_widget.dart';
  import './widgets/session_timer_widget.dart';

  class AudioCallScreen extends StatefulWidget {
    final String channel;
    final String token;
    final String sessionId;
    final int rtcUid;

    const AudioCallScreen({
      Key? key,
      required this.channel,
      required this.token,
      required this.sessionId,
      required this.rtcUid,
    }) : super(key: key);

    @override
    State<AudioCallScreen> createState() => _AudioCallScreenState();
  }

  late StreamSubscription _callEventsSub;

  class _AudioCallScreenState extends State<AudioCallScreen> {

    Timer? _sessionTimer;
    Duration _elapsedTime = Duration.zero;
    bool _isPaused = false;
    bool _isMuted = false;
    bool _isSpeakerOn = false;
    bool _showNotes = false;
    String _sessionNotes = '';

    bool _joinedAgora = false;

    @override
    void initState() {
      super.initState();

      print("🔥 AudioCallScreen Loaded (Astrologer)");
      _startSessionTimer();

      initAgora();

      // LISTEN FOR SESSION ENDED
      _callEventsSub = ChatSocketService.eventsStream.listen((event) {
        if (event["event"] == "session_ended") {
          _handleRemoteEnd(event);
        }
      });
    }


    void _handleRemoteEnd(Map event) {
      print("📞 session_ended received -> $event");
      // ensure we leave agora safely
      AgoraService.leaveChannel().catchError((_) {});
      if (!mounted) return;

      // dismiss any dialogs/popups first
      try { Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst); } catch (_) {}

      // navigate to dashboard root
      Navigator.pushNamedAndRemoveUntil(context, "/dashboard-screen", (r) => false);
    }


    Future<void> initAgora() async {
      await Permission.microphone.request();

      try {
        await AgoraService.init(); // AGORA_APP_ID already used inside

        await AgoraService.joinChannel(
          token: widget.token,
          channel: widget.channel,
          uid: widget.rtcUid,
        );

        print("ASTROLOGER USING BACKEND RTC UID: $widget.rtcUid");
        print("JOINING AGORA (ASTRO): channel=${widget.channel}");

        setState(() => _joinedAgora = true);
        print("✅ ASTROLOGER JOINED AGORA");
      } catch (e, st) {
        print("❌ initAgora error: $e\n$st");
      }
    }

    @override
    void dispose() {
      _callEventsSub.cancel();
      _sessionTimer?.cancel();

      AgoraService.leaveChannel().catchError((_) {});

      super.dispose();
    }


    void _startSessionTimer() {
      _sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (!_isPaused) {
          setState(() => _elapsedTime += Duration(seconds: 1));
        }
      });
    }

    double get _totalEarnings {
      return (_elapsedTime.inSeconds / 60) * 10;
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClientAvatarWidget(
                          clientName: "Rahul",
                          clientAvatar:
                          "https://images.unsplash.com/photo-1711989691590-c9510a936e93",
                          consultationType: "Audio Call",
                        ),

                        SessionTimerWidget(
                          elapsedTime: _elapsedTime,
                          earningsPerMinute: 20,
                          totalEarnings: _totalEarnings,
                          isPaused: _isPaused,
                          onPauseToggle: _togglePause,
                        ),
                      ],
                    ),
                  ),

                  CallControlsWidget(
                    isMuted: _isMuted,
                    isSpeakerOn: _isSpeakerOn,
                    onMuteToggle: _toggleMute,
                    onSpeakerToggle: _toggleSpeaker,
                    onEndCall: _endCall,
                    onShowNotes: _toggleNotes,
                  ),

                  SizedBox(height: 2.h),
                ],
              ),

              if (_showNotes)
                NotesOverlayWidget(
                  initialNotes: _sessionNotes,
                  onNotesChanged: (notes) => _sessionNotes = notes,
                  onClose: () => setState(() => _showNotes = false),
                ),
            ],
          ),
        ),
      );
    }

    Widget _buildTopBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _showSessionInfo,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 2.w),
                    Text("Session Info", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

            Text("HD AUDIO",
                style: TextStyle(color: Colors.greenAccent, fontSize: 14)),
          ],
        ),
      );
    }

    void _toggleMute() {
      setState(() => _isMuted = !_isMuted);
      AgoraService.engine?.muteLocalAudioStream(_isMuted);
    }

    void _toggleSpeaker() async {
      setState(() => _isSpeakerOn = !_isSpeakerOn);
      await AgoraService.engine
          ?.setEnableSpeakerphone(_isSpeakerOn);
    }

    void _togglePause() {
      setState(() => _isPaused = !_isPaused);
    }

    void _toggleNotes() {
      setState(() => _showNotes = !_showNotes);
    }

    void _showSessionInfo() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black,
        builder: (_) => SessionInfoSheetWidget(
          consultationTopic: "Audio Call",
          agreedDuration: Duration(minutes: 30),
          ratePerMinute: 20,
          sessionId: widget.sessionId,
          startTime: DateTime.now(),
        ),
      );
    }

    Future<void> _endCall({String reason = "ended_by_user"}) async {
      try {
        // 1) Notify backend (best-effort)
        try {
          await ApiClient.post("/chat-session/end", {
            "sessionId": widget.sessionId,
            "reason": reason,
          });
          print("✅ Notified backend session end: ${widget.sessionId} reason=$reason");
        } catch (apiErr) {
          // still proceed to leave agora — we logged the backend failure
          print("⚠️ Failed to notify backend about ending session: $apiErr");
        }

        // 2) Leave Agora
        try {
          await AgoraService.leaveChannel();
          print("✅ Left Agora channel");
        } catch (agoraErr) {
          print("⚠️ Error leaving Agora channel: $agoraErr");
        }

        // 3) Close UI properly — pop stack and go to dashboard root
        // prefer pushReplacement or named remove until root to avoid returning to calling UI
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/dashboard-screen",
              (route) => false,
        );
      } catch (e) {
        print("❌ _endCall failed: $e");
        // fallback: at least try to pop
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    }


  }
