import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _audioPlayer.setVolume(0.5); // Set volume to 50%
      _isInitialized = true;
    }
  }

  static Future<void> play() async {
    await initialize();
    await _audioPlayer.play(AssetSource('audio/background.mp3'));
  }

  static Future<void> pause() async {
    await _audioPlayer.pause();
  }

  static Future<void> stop() async {
    await _audioPlayer.stop();
  }

  static Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  static void dispose() {
    _audioPlayer.dispose();
  }
}
