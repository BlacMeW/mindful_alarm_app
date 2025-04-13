import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class RingtoneUtils {
  static void playRingtone() {
    FlutterRingtonePlayer().playAlarm(
      asAlarm: true,
      looping: true,
      volume: 1.0,
    );
  }

  static void playRingtoneOnce() {
    FlutterRingtonePlayer().playAlarm(
      asAlarm: true,
      looping: false,
      volume: 1.0,
    );
  }

  static void stopRingtone() {
    FlutterRingtonePlayer().stop();
  }
}
