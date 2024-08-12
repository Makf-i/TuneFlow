import 'package:TuneFlow/providers/song_manager.dart';
import 'package:TuneFlow/widgets/song_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Iterable<Widget> _getSuggestions(SearchController controller) {
    final listOfSongs = ref.read(songProvider);
    final String input = controller.value.text.toLowerCase();
    return listOfSongs
        .where(
          (element) =>
              element.name.toLowerCase().contains(input) ||
              element.artist.toLowerCase().contains(input),
        )
        .map(
          (sng) => SongButton(
            song: sng,
            id: sng.id,
            closeKeyboard: () {
              controller.closeView(input);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Screen"),
      ),
      body: SearchAnchor.bar(
        barHintText: 'Looking for a Song',
        suggestionsBuilder: (context, controller) {
          return _getSuggestions(controller);
        },
      ),
    );
  }
}
