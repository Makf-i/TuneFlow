import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/song.dart';

class SongNotifier extends StateNotifier<List<Song>> {
  SongNotifier() : super([]);

  // Load songs from a source and initialize the state
  void loadSongs(List<Song> songs) {
    state = songs;
  }

  //updating the status of global list songs
  // Update a specific song's running status
  void updateSongRunningStatus(String songId, bool isRunning) {
    state = [
      for (Song song in state)
        if (song.id == songId) song.copyWith(isRunning: isRunning) else song
    ];
  }

  // Add new songs to the list
  void addSong(Song song) {
    state = [...state, song];
  }
}

final songProvider = StateNotifierProvider<SongNotifier, List<Song>>((ref) {
  return SongNotifier();
});
