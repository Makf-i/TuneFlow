import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  PlayerState? _playerState;
  String? _currentSongLocation;

  // Stream to notify listeners of the currently playing song
  final StreamController<String?> _songStreamController =
      StreamController.broadcast();
  Stream<String?> get songStream => _songStreamController.stream;

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
    _addSongToStream(location);
  }

  Future<void> stop() async {
    await _player.stop();
    _playerState = PlayerState.stopped;
    _currentSongLocation = null;
    _addSongToStream(null); // Notify that no song is playing
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

  void _addSongToStream(String? location) {
    if (!_songStreamController.isClosed) {
      _songStreamController.add(location);
    }
  }

  void dispose() {
    _songStreamController.close();
  }
}
