import 'package:TuneFlow/providers/song_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/widgets/audiomanager.dart';

final AudioManager audioManager = AudioManager();

class PlayerBottom extends ConsumerStatefulWidget {
  const PlayerBottom({super.key});

  @override
  ConsumerState<PlayerBottom> createState() => _PlayerBottomState();
}

class _PlayerBottomState extends ConsumerState<PlayerBottom> {
  @override
  Widget build(BuildContext context) {
    // Watch the song provider to get the current list of songs
    final songManagerState = ref.watch(songProvider);

    // Watch for changes in the last played song
    final lastPlayedSong = ref.watch(songProvider.notifier).lastPlayedSong;

    if (lastPlayedSong == null) {
      return const SizedBox.shrink();
    }

    // Check if the song is currently playing
    final isPlaying =
        songManagerState.any((s) => s.isPlaying && s.id == lastPlayedSong.id);

    final smallLike = songManagerState
        .firstWhere((element) => element.id == lastPlayedSong.id);
    final isSmallLikeFav = smallLike.isFavorite;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        backgroundBlendMode: BlendMode.softLight,
        color: Color.fromARGB(255, 159, 158, 158),
      ),
      padding: const EdgeInsets.all(10),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lastPlayedSong.name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                lastPlayedSong.artist,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  final wasAdded = ref
                      .read(songProvider.notifier)
                      .toggleFavoriteStatus(smallLike);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(wasAdded
                          ? "Added to Favorites"
                          : "Removed from Favorites"),
                    ),
                  );
                },
                icon: Icon(
                  isSmallLikeFav
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: isSmallLikeFav ? Colors.red : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await audioManager.pause();
                    ref
                        .read(songProvider.notifier)
                        .updateSongRunningStatus(lastPlayedSong.id, false);
                  } else {
                    await audioManager.resume();
                    ref
                        .read(songProvider.notifier)
                        .updateSongRunningStatus(lastPlayedSong.id, true);
                  }
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
            ],
          )
        ],
      ),
    );
  }
}
