import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlarmService {
  static void triggerAlarm() {
    final ringtonePlayer = FlutterRingtonePlayer();
    ringtonePlayer.playAlarm(asAlarm: true, looping: true, volume: 1.0);
  }
}
