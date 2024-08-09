import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/providers/favorite_song.dart';
import 'package:TuneFlow/screens/liked_screen.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});
  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  void _goToLikedScreen() {
    //watching for any changes in favoritesongsprovider
    final favoriteSongs = ref.watch(favoriteSongProvider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LikedScreen(
          song: favoriteSongs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextButton.icon(
                  icon: Image.asset(
                    'assets/images/liked_song.png',
                    width: 23,
                    height: 24,
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: _goToLikedScreen,
                  label: const Text(
                    "Liked Screen",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
