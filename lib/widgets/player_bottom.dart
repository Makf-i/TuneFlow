import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/providers/songbutton_provider.dart';
import 'package:TuneFlow/widgets/audiomanager.dart';

class PlayerBottom extends ConsumerStatefulWidget {
  const PlayerBottom({
    super.key,
    required this.song,
  });

  final Song song;

  @override
  ConsumerState<PlayerBottom> createState() => _PlayerBottomState();
}

class _PlayerBottomState extends ConsumerState<PlayerBottom> {
  final AudioManager _audioManager = AudioManager();

  @override
  Widget build(BuildContext context) {
    final songButtonNotifier =
        ref.read(songButtonProvider(widget.song).notifier);
    return GestureDetector(
      onTap: () {
        // Navigate to full player screen if desired
      },
      child: Container(
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
                  widget.song.name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.song.artist,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            IconButton(
              onPressed: widget.song.isRunning
                  ? () async {
                      await _audioManager.pause();
                      songButtonNotifier.toggleRunningStatus();
                    }
                  : () async {
                      await _audioManager.resume();
                      songButtonNotifier.toggleRunningStatus();
                    },
              icon: widget.song.isRunning
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
