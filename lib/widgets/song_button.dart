import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/providers/favorite_song.dart';
import 'package:TuneFlow/providers/song_provider.dart';
import 'package:TuneFlow/providers/songbutton_provider.dart';
import 'package:TuneFlow/widgets/audiomanager.dart'; // import the AudioManager class

class SongButton extends ConsumerStatefulWidget {
  const SongButton({
    super.key,
    this.id = '',
    required this.song,
  });
  final String id;
  final Song song;

  @override
  ConsumerState<SongButton> createState() {
    return _SongButtonState();
  }
}

class _SongButtonState extends ConsumerState<SongButton> {
  final AudioManager _audioManager = AudioManager();

  @override
  Widget build(BuildContext context) {
    //for Favorite Song
    final favoriteSongs = ref.watch(favoriteSongProvider);
    final isFavorite = favoriteSongs.contains(widget.song);

    final songButtonState = ref.watch(songButtonProvider(widget.song));
    final songButtonNotifier =
        ref.read(songButtonProvider(widget.song).notifier);

    bool color = ref.watch(songProvider).any((c) => c.isRunning && c.id == widget.song.id);

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  songButtonState.song.name,
                  style: color
                      ? const TextStyle(
                          color: Color.fromARGB(255, 0, 213, 241))
                      : const TextStyle(color: Colors.white70),
                ),
                subtitle: Text(songButtonState.song.artist),
                onTap: songButtonState.isRunning
                    ? null
                    : () async {
                        await _audioManager.play(songButtonState.song.location);
                        songButtonNotifier.toggleRunningStatus();
                      },
              ),
            ),

            //pause the Song
            // IconButton(
            //   onPressed: _isPlaying || _isPaused || songButtonState.isRunning
            //       ? () async {

            //           await _audioManager.stop();
            //           songButtonNotifier.toggleRunningStatus();
            //           setState(() {
            //             _playerState = PlayerState.stopped;
            //             _isSongPlaying = false;
            //           });
            //         }
            //       : null,
            //   icon: !songButtonState.isRunning
            //       ? const Icon(Icons.pause)
            //       : const Icon(Icons.play_arrow),
            // ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (ctx) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            final wasAdded = ref
                                .read(favoriteSongProvider.notifier)
                                .toggleSongFavoriteStatus(widget.song);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(wasAdded
                                    ? "Added to Favorites"
                                    : 'Removed from Favorties'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: isFavorite
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border_outlined),
                          label: const Text("Add to Liked Songs"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ),
      ],
    );
  }
}

// const Spacer(),
// Text(
//   widget.title,
//   style: Theme.of(context).textTheme.titleMedium!.copyWith(
//         color: Theme.of(context).colorScheme.primary,
//       ),
// ),
// const Spacer(),
// SizedBox(
//   width: 100,
//   child: Text(
//     widget.artist,
//     overflow: TextOverflow.ellipsis,
//     style: Theme.of(context).textTheme.titleMedium!.copyWith(
//           color: Theme.of(context).colorScheme.primary,
//         ),
//   ),
// ),
// const Spacer(),
// Text(
//   widget.duration,
//   style: Theme.of(context).textTheme.titleMedium!.copyWith(
//         color: Theme.of(context).colorScheme.primary,
//       ),
// ),
// IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow)),
// IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
// IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
