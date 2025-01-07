import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer gamePlayer = AudioPlayer();
  final AudioPlayer lobbyPlayer = AudioPlayer();
  bool isSoundEnabled = true;

  // Sound paths
  static const String greenLightPath = 'sounds/green_light.mp3';
  static const String whilePlayingPath = 'sounds/while_playing.mp3';
  static const String redLightPath = 'sounds/red_light.mp3';
  static const String eliminatedPath = 'sounds/eliminated.mp3';
  static const String lobbyMusicPath = 'sounds/lobby_music.mp3';

  Future<void> playGameSound(String soundType) async {
    if (!isSoundEnabled) return;

    try {
      if (soundType == 'green') {
        await gamePlayer.stop();
        await gamePlayer.play(AssetSource(greenLightPath));
        await Future.delayed(Duration(seconds: 2));
        await gamePlayer.play(AssetSource(whilePlayingPath));
        await Future.delayed(Duration(seconds: 11));
        await gamePlayer.stop();
      } else if (soundType == 'red') {
        await gamePlayer.stop();
        await gamePlayer.play(AssetSource(redLightPath));
        await Future.delayed(Duration(seconds: 5));
        await gamePlayer.stop();
      } else if (soundType == 'eliminated') {
        await gamePlayer.stop();
        await gamePlayer.play(AssetSource(eliminatedPath));
      }
    } catch (e) {
      print('Error playing game sound: $e');
    }
  }

  Future<void> playLobbyMusic() async {
    try {
      await lobbyPlayer.setSource(AssetSource(lobbyMusicPath));
      await lobbyPlayer.setVolume(0.0);
      await lobbyPlayer.setReleaseMode(ReleaseMode.loop);
      await lobbyPlayer.resume();

      const fadeSeconds = 2.0;
      const targetVolume = 0.5;
      const steps = 20;

      for (var i = 1; i <= steps; i++) {
        await Future.delayed(
            Duration(milliseconds: (fadeSeconds * 1000 ~/ steps)));
        await lobbyPlayer.setVolume((targetVolume / steps) * i);
      }
    } catch (e) {
      print('Error playing lobby music: $e');
    }
  }

  void stopLobbyMusic() {
    lobbyPlayer.stop();
  }

  void dispose() {
    gamePlayer.dispose();
    lobbyPlayer.dispose();
  }
}
