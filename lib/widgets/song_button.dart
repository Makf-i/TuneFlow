import 'dart:ffi';

import 'package:TuneFlow/providers/song_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/widgets/audiomanager.dart';

class SongButton extends ConsumerStatefulWidget {
  const SongButton({
    super.key,
    required this.id,
    required this.song,
    this.closeKeyboard,
  });
  final String id;
  final Song song;
  final void Function()? closeKeyboard;

  @override
  ConsumerState<SongButton> createState() {
    return _SongButtonState();
  }
}

class _SongButtonState extends ConsumerState<SongButton> {
  final AudioManager _audioManager = AudioManager();
  String? _currentPlayingSongLocation;

  @override
  void initState() {
    super.initState();
    _audioManager.songStream.listen((location) {
      setState(() {
        _currentPlayingSongLocation = location;
      });
    });
  }

  @override
  void dispose() {
    _audioManager.dispose(); // Dispose AudioManager resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current playing song from the SongManagerNotifier
    final songManager = ref.watch(songProvider.notifier);

    // Determine if the song is currently playing
    final isCurrentlyPlaying =
        _currentPlayingSongLocation == widget.song.location;
    final isFavorite = widget.song.isFavorite;

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  widget.song.name,
                  style: TextStyle(
                    color: isCurrentlyPlaying
                        ? const Color.fromARGB(255, 0, 213, 241)
                        : Colors.white70,
                  ),
                ),
                subtitle: Text(widget.song.artist),
                onTap: () async {
                  // Play the song and update the global state
                  await _audioManager.play(widget.song.location);
                  songManager.toggleRunningStatus(widget.song);
                  print('Song started playing');
                  widget.closeKeyboard!.call();
                },
              ),
            ),
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
                            final wasAdded =
                                songManager.toggleFavoriteStatus(widget.song);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(wasAdded
                                    ? "Added to Favorites"
                                    : "Removed from Favorites"),
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
