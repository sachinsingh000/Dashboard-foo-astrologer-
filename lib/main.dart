  import 'package:astropro_provider/presentation/consultation_requests_screen/consultation_requests_screen.dart';
  import 'package:astropro_provider/services/chat_socket_service.dart';
  import 'package:astropro_provider/services/global_notification_service.dart';
  import 'package:astropro_provider/services/storage_service.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:sizer/sizer.dart';

  import '../core/app_export.dart';
  import '../widgets/custom_error_widget.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    bool _hasShownError = false;

    // Error widget override
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (!_hasShownError) {
        _hasShownError = true;

        Future.delayed(const Duration(seconds: 5), () {
          _hasShownError = false;
        });

        return CustomErrorWidget(errorDetails: details);
      }
      return const SizedBox.shrink();
    };

    // ❗ FIRST initialize SharedPreferences
    await StorageService.init();

    // Orientation lock
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final astroId = StorageService.getAstrologerId();
    if (astroId != null) {
      ChatSocketService.connect(id: astroId);

      ChatSocketService.requestsStream.listen((req) {
        GlobalNotificationService.showBanner(
          title: req["userName"] ?? "Unknown",
          type: req["consultationType"] ?? "chat",
          avatarUrl: req["userImage"] ?? "",
          onTap: () {
            Navigator.push(
              GlobalNotificationService.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => ConsultationRequestsScreen()),
            );
          },
        );
      });
    }


    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Sizer(builder: (context, orientation, screenType) {
        return MaterialApp(
          navigatorKey: GlobalNotificationService.navigatorKey,
          title: 'astrologer_dashboard',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.initial,

          builder: (context, child) {
            return Overlay(
              initialEntries: [
                OverlayEntry(builder: (_) => child!),
              ],
            );
          },
        );
      });
    }
  }
