import "dart:developer";
import "package:audioplayers/audioplayers.dart";
import "../../ux/res/app_sounds.dart";

class SoundUtil {

  static const String _tag = "SoundUtil";
  static final AudioPlayer player = AudioPlayer();

  static Future<void> playTone() async {
    try {
      await player.play(AssetSource(AppSounds.audSuccess));
    } catch(e) {
      log("$_tag:: Player exception caught:: ${e.toString()}");
    }
  }

}
