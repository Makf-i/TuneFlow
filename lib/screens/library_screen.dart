import 'package:TuneFlow/providers/screen_provider.dart';
import 'package:TuneFlow/providers/song_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});
  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songProvider);
    final favoriteSongs = songs.where((element) => element.isFavorite);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text(
              "Liked Screen",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.start,
            ),
            leading: Image.asset(
              'assets/images/liked_song.png',
              width: 23,
              height: 24,
              alignment: Alignment.centerLeft,
            ),
            onTap: () {
              ref.read(screenProvider.notifier).gotToLikedScreen(favoriteSongs);
            },
          )
        ],
      ),
    );
  }
}
