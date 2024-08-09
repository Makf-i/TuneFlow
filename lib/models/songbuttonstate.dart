//Creating a Class for SongButtonState

import 'package:TuneFlow/models/song.dart';

class SongButtonState {
  const SongButtonState({
    required this.song,
    this.isRunning = false,
  });
  final Song song;
  final bool isRunning;
  //This copyWith method is a common pattern used in Dart, especially with immutable classes,
  //to create a new instance with some updated values while keeping the existing ones unchanged.
  SongButtonState copyWith({Song? song, bool? isRunning}) {
    return SongButtonState(
      song: song ?? this.song,
      isRunning: isRunning ?? this.isRunning,
    );
  }
  //song: song ?? this.song: If a new song value is provided, it uses that value; otherwise,
  //it keeps the existing song value (this.song).
  //isRunning: isRunning ?? this.isRunning: Similarly, if a new isRunning value is provided,
  //it uses that value; otherwise, it keeps the existing isRunning value (this.isRunning).
  //a ?? b evaluates to a if a is not null; otherwise, it evaluates to b
}
