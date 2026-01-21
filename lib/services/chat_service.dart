import 'dart:convert';

import 'package:astropro_provider/services/storage_service.dart';
import 'api_client.dart';
import 'config.dart';

class ChatService {
  // ---------------- CHAT SESSIONS ----------------

  static Future<Map<String, dynamic>> fetchChatSessions() async {
    final res = await ApiClient.get("/chat-session/list");

    return {
      "active": res["active"] ?? [],
      "past": res["past"] ?? [],
    };
  }

  static Future<void> cancelRinging(String sessionId) async {
    await ApiClient.post(
      "/chat-request/cancel-astrologer-ringing",
      {"sessionId": sessionId},
    );
  }

  static Future<Map<String, dynamic>> startChat({
    required String sessionId,
  }) async {
    return await ApiClient.post(
      "/chat/start",
      {"sessionId": sessionId},
    );
  }

  static Future<Map<String, dynamic>> endChat({
    required String sessionId,
  }) async {
    return await ApiClient.post(
      "/chat/end",
      {"sessionId": sessionId},
    );
  }

  static Future<List<dynamic>> getMessages(String sessionId) async {
    final res = await ApiClient.get("/chat/$sessionId/messages");
    return res["messages"] ?? [];
  }

  // ---------------- CHAT REQUESTS (ASTROLOGER) ----------------

  /// Fetch astrologer's pending requests
  static Future<List<Map<String, dynamic>>> fetchRequests() async {
    final res = await ApiClient.get("/chat-request");

    return List<Map<String, dynamic>>.from(res["requests"] ?? []);
  }

  /// Accept request
  static Future<void> accept(String sessionId) async {
    await ApiClient.post(
      "/chat-request/accept",
      {"sessionId": sessionId},
    );
  }

  /// Decline request
  static Future<void> decline(String sessionId, String reason) async {
    await ApiClient.post(
      "/chat-request/decline",
      {
        "sessionId": sessionId,
        "reason": reason,
      },
    );
  }
}
