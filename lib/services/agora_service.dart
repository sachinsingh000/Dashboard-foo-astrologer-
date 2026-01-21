import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'api_client.dart';
import 'config.dart';

class AgoraService {
  static RtcEngine? _engine;
  static RtcEngine? get engine => _engine;

  // ---------- FETCH TOKEN ----------
  static Future<Map<String, dynamic>> fetchToken(String channel) async {
    return await ApiClient.post('/agora/token', {
      "channel": channel,
    });
  }

  // ---------- INIT ----------
  static Future<void> init() async {
    if (_engine != null) return;

    _engine = createAgoraRtcEngine();

    await _engine!.initialize(
      RtcEngineContext(appId: AGORA_APP_ID),
    );

    await _engine!.enableAudio();
    await _engine!.setDefaultAudioRouteToSpeakerphone(true);
    await _engine!.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );
  }

  static Future<void> joinChannel({
    required String token,
    required String channel,
    required int uid,
  }) async {
    if (_engine == null) {
      throw Exception("Agora not initialized");
    }

    await _engine!.joinChannel(
      token: token,
      channelId: channel,
      uid: uid,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  static Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
  }

  static Future<void> dispose() async {
    await _engine?.release();
    _engine = null;
  }
}
