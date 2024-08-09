import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/songbuttonstate.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/providers/song_provider.dart';

class SongButtonNotifier extends StateNotifier<SongButtonState> {
  final Ref ref;

  //what kind of state is managed by the notifier must be given
  //SongButtonState is the type of state being managed by this notifier.
  SongButtonNotifier(SongButtonState state, this.ref) : super(state);
  //This constructor initializes the SongButtonNotifier with an initial state,
  //which is passed to the super constructor of StateNotifier.

  void toggleRunningStatus() {
    final newStatus = !state.isRunning;
    state = state.copyWith(isRunning: newStatus);
    //This method toggles the isRunning status of the state.
    //state.copyWith(isRunning: !state.isRunning) creates a new SongButtonState
    //with isRunning set to the opposite of its current value (!state.isRunning).
    //state = assigns the new state to the state property of StateNotifier,
    //which triggers updates to any listeners of this notifier.

    //To Update the running status in the global song list
    ref
        .read(songProvider.notifier)
        .updateSongRunningStatus(state.song.id, newStatus);
  }

  void updateSong(Song song) {
    state = state.copyWith(song: song);
  }
}

//The family modifier allows the provider to be parameterized.
//This means you can create multiple instances of the provider,
//each with different parameters.
final songButtonProvider =
    StateNotifierProvider.family<SongButtonNotifier, SongButtonState, Song>(
        (ref, song) => SongButtonNotifier(SongButtonState(song: song), ref));
