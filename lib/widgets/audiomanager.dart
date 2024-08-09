import 'package:audioplayers/audioplayers.dart';

//AUDIOPLAYER is managed using this AudioManager

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  PlayerState? _playerState;
  String? _currentSongLocation;

  bool get isPlaying => _playerState == PlayerState.playing;
  bool get isPaused => _playerState == PlayerState.paused;

  Future<void> play(String location) async {
    if (isPlaying || isPaused) {
      await stop();
    }

    final source = UrlSource(location);
    await _player.play(source);
    _playerState = PlayerState.playing;
    _currentSongLocation = location;
  }

  Future<void> stop() async {
    await _player.stop();
    _playerState = PlayerState.stopped;
  }

  Future<void> pause() async {
    if (isPlaying) {
      await _player.pause();
      _playerState = PlayerState.paused;
    }
  }

  Future<void> resume() async {
    if (isPaused) {
      await _player.resume();
      _playerState = PlayerState.playing;
    }
  }
}