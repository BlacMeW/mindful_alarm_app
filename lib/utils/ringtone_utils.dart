import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class RingtoneUtils {
  static void playRingtone() {
    FlutterRingtonePlayer().playAlarm(
      asAlarm: true,
      looping: true,
      volume: 1.0,
    );
  }

  static Future<void> delayRingtoneStop() async {
    await Future.delayed(Duration(seconds: 20));
  }

  static void playRingtoneOnce() {
    FlutterRingtonePlayer().playAlarm(
      asAlarm: false,
      looping: false,
      volume: 1.0,
    );

    // FlutterRingtonePlayer().stop();
  }

  static void stopRingtone() {
    delayRingtoneStop();
    FlutterRingtonePlayer().stop();
  }
}
