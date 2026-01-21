import 'package:flutter/material.dart';

class GlobalNotificationService {
    static final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

    static void showBanner({
        required String title,
        required String type,
        required String avatarUrl,
        required VoidCallback onTap,
    }) {
        // TEMP: no-op
    }
}
