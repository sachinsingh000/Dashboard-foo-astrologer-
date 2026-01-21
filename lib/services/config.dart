// lib/config.dart

/// 🔹 Toggle this when needed
const bool IS_EMULATOR = false;

/// 🔹 Base host
const String _EMULATOR_HOST = "10.0.2.2";
const String _DEVICE_HOST   = "10.67.135.207"; // ✅ current PC IPv4

/// 🔹 Port
const int BACKEND_PORT = 4000;

/// 🔹 REST base
String get baseUrl =>
    "http://$_resolvedHost:$BACKEND_PORT/api";

/// 🔹 Socket base
String get socketBaseUrl =>
    "http://$_resolvedHost:$BACKEND_PORT";

String get _resolvedHost =>
    IS_EMULATOR ? _EMULATOR_HOST : _DEVICE_HOST;

/// 🔹 Agora
const String AGORA_APP_ID =
    "3ae52cdbec2e4a39910829bb18b3f8c8";
