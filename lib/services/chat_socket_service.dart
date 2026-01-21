import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'config.dart';

class ChatSocketService {
    static IO.Socket? _socket;

    static final _requestsController =
    StreamController<Map<String, dynamic>>.broadcast();

    static final _eventsController =
    StreamController<Map<String, dynamic>>.broadcast();

    static Stream<Map<String, dynamic>> get requestsStream =>
        _requestsController.stream;

    static Stream<Map<String, dynamic>> get eventsStream =>
        _eventsController.stream;

    static Future<void> connect({required String id}) async {
        if (_socket != null && _socket!.connected) return;

        _socket = IO.io(
            socketBaseUrl,
            IO.OptionBuilder()
                .setTransports(['websocket'])
                .disableAutoConnect()
                .build(),
        );

        _socket!.connect();

        _socket!.onConnect((_) {
            _socket!.emit("login", {"astrologerId": id});
        });

        _socket!.on("incoming_request", (data) {
            if (data is Map) {
                _requestsController.add(Map<String, dynamic>.from(data));
            }
        });

        _socket!.on("chat_event", (data) {
            if (data is Map) {
                _eventsController.add(Map<String, dynamic>.from(data));
            }
        });
    }

    static void sendMessage({
        required String sessionId,
        required String message,
    }) {
        _socket?.emit("send_message", {
            "sessionId": sessionId,
            "message": message,
        });
    }

    static void leaveSession(String sessionId) {
        _socket?.emit("leave_session", {"sessionId": sessionId});
    }

    static void disconnect() {
        _socket?.disconnect();
        _socket?.dispose();
        _socket = null;
    }
}
