import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/providers/favorite_song.dart';
import 'package:TuneFlow/providers/song_provider.dart';
import 'package:TuneFlow/widgets/player_bottom.dart';
import 'package:TuneFlow/widgets/song_button.dart';

class LikedScreen extends ConsumerStatefulWidget {
  const LikedScreen({super.key, required this.song});

  final List<Song> song;

  @override
  ConsumerState<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends ConsumerState<LikedScreen> {
  @override
  Widget build(BuildContext context) {
    Widget bat = const Text("No thing playing");
    final favoriteSongs = ref.watch(favoriteSongProvider);
    final listSong = ref.watch(songProvider);
    for(Song sng in listSong){
      if(sng.isRunning){
        bat = PlayerBottom(song: sng);
      }
    }
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: bat,
      body: ListView.builder(
          itemCount: favoriteSongs.length,
          itemBuilder: (context, index) => SongButton(
                song: favoriteSongs[index],
              )),
    );
  }
}
