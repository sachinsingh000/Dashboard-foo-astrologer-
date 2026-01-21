import 'package:flutter/material.dart';
import '../presentation/chat_list_screen/chat_list_screen.dart';
import '../presentation/video_call_screen/video_call_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/profile_management_screen/profile_management_screen.dart';
import '../presentation/wallet_and_earnings_screen/wallet_and_earnings_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/consultation_requests_screen/consultation_requests_screen.dart';
import '../presentation/audio_call_screen/audio_call_screen.dart';
import '../presentation/chat_interface_screen/chat_interface_screen.dart';
import '../presentation/kyc_verification_screen/kyc_verification_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/report_editor_screen/report_editor_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String videoCall = '/video-call-screen';
  static const String dashboard = '/dashboard-screen';
  static const String splash = '/splash-screen';
  static const String profileManagement = '/profile-management-screen';
  static const String walletAndEarnings = '/wallet-and-earnings-screen';
  static const String login = '/login-screen';
  static const String consultationRequests = '/consultation-requests-screen';
  static const String audioCall = '/audio-call-screen';
  static const String chatInterface = '/chat-interface-screen';
  static const String kycVerification = '/kyc-verification-screen';
  static const String registration = '/registration-screen';
  static const String reportEditor = '/report-editor-screen';
  static const String chatList = '/chat-list-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    videoCall: (context) => const VideoCallScreen(),
    dashboard: (context) => const DashboardScreen(),
    splash: (context) => const SplashScreen(),
    profileManagement: (context) => const ProfileManagementScreen(),
    walletAndEarnings: (context) => const WalletAndEarningsScreen(),
    login: (context) => const LoginScreen(),
    consultationRequests: (context) => const ConsultationRequestsScreen(),
    audioCall: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (args == null) {
        return const Scaffold(
          body: Center(child: Text("Missing call parameters")),
        );
      }

      return AudioCallScreen(
        channel: args["channel"],
        token: args["token"],
        sessionId: args["sessionId"],
        rtcUid: 0,
      );
    },
    chatInterface: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (args == null) {
        // fallback to avoid crash when no args passed
        return ChatInterfaceScreen(
          roomId: 'unknown_room',
          sessionId: 'unknown_session',
          clientData: {'name': 'Unknown', 'avatar': '', 'ratePerMinute': 0.0},
        );
      }

      return ChatInterfaceScreen(
        roomId: args["roomId"] as String,
        sessionId: args["sessionId"] as String,
        clientData: args["client"] as Map<String, dynamic>,
      );
    },

    kycVerification: (context) => const KycVerificationScreen(),
    registration: (context) => const RegistrationScreen(),
    reportEditor: (context) => const ReportEditorScreen(),
    // TODO: Add your other routes here
    chatList: (context) => const ChatListScreen(),

  };
}
