import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/song.dart';

class FavoriteSongNotifier extends StateNotifier<List<Song>> {
  FavoriteSongNotifier() : super([]);

  bool toggleSongFavoriteStatus(Song song) {
    //checking whether the song is already a favorite or not
    final songIsFavorite = state.contains(song);

    if (songIsFavorite) {
      //remove the song thats already present
      state = state.where((s) => s.id != song.id).toList();
      return false; //return false if item was removed
    } else {
      //add the song which is liked to the list
      state = [...state, song];
      return true; //return true if item was added
    }
  }
}

final favoriteSongProvider =
    StateNotifierProvider<FavoriteSongNotifier, List<Song>>(
        (ref) => FavoriteSongNotifier());
