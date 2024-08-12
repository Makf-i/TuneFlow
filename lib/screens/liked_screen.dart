import 'package:TuneFlow/providers/song_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/widgets/song_button.dart';

class LikedScreen extends ConsumerStatefulWidget {
  const LikedScreen({super.key});

  @override
  ConsumerState<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends ConsumerState<LikedScreen> {
  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songProvider);
    final favoriteSongs = songs.where((element) => element.isFavorite).toList();
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: favoriteSongs.length,
          itemBuilder: (context, index) => SongButton(
                song: favoriteSongs[index],
                id: favoriteSongs[index].id,
              )),
    );
  }
}
