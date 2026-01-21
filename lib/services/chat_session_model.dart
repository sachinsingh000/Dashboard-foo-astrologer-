// lib/services/chat_session_model.dart
enum ChatType { chat, audio, video }

class ChatSessionModel {
  final String id;
  final String roomId;
  final String userId;
  final String astrologerId;
  final String userName;
  final String? userImage;
  final bool isActive;
  final String status; // running|paused|expired|ended
  final double ratePerMinute;
  final DateTime? startedAt;
  final DateTime? endsAt;
  final ChatType type;
  final String? title;

  ChatSessionModel({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.astrologerId,
    required this.userName,
    this.userImage,
    required this.isActive,
    required this.status,
    required this.ratePerMinute,
    this.startedAt,
    this.endsAt,
    required this.type,
    this.title,
  });

  String get userInitials {
    if (userName.trim().isEmpty) return 'U';
    final parts = userName.split(' ');
    final a = parts.isNotEmpty ? parts[0][0] : '';
    final b = parts.length > 1 ? parts[1][0] : '';
    return (a + b).toUpperCase();
  }

  String get statusLabel {
    switch (status) {
      case 'running':
        return 'Active';
      case 'paused':
        return 'Paused';
      case 'expired':
        return 'Expired';
      case 'ended':
        return 'Ended';
      default:
        return status;
    }
  }

  String get typeLabel {
    switch (type) {
      case ChatType.audio:
        return 'Audio';
      case ChatType.video:
        return 'Video';
      default:
        return 'Chat';
    }
  }

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    ChatType parseType(String? t) {
      if (t == null) return ChatType.chat;
      final s = t.toLowerCase();
      if (s.contains('video')) return ChatType.video;
      if (s.contains('audio')) return ChatType.audio;
      if (s.contains('call')) return ChatType.audio;
      return ChatType.chat;
    }

    return ChatSessionModel(
      id: json['_id'] ?? json['id'] ?? '',
      roomId: json['roomId'] ?? '',
      userId: json['userId']?.toString() ?? '',
      astrologerId: json['astrologerId']?.toString() ?? '',
      userName: (json['user'] != null ? (json['user']['name'] ?? '') : (json['userName'] ?? json['clientName'] ?? 'Unknown')),
      userImage: json['user'] != null ? (json['user']['image'] ?? '') : json['userImage'],
      isActive: json['isActive'] == true,
      status: json['status'] ?? (json['isActive'] == true ? 'running' : 'ended'),
      ratePerMinute: (json['ratePerMinute'] ?? json['chatPrice'] ?? 0).toDouble(),
      startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt']) : null,
      endsAt: json['endsAt'] != null ? DateTime.tryParse(json['endsAt']) : null,
      type: parseType(json['type'] ?? json['sessionType'] ?? 'chat'),
      title: json['title'],
    );
  }
}
