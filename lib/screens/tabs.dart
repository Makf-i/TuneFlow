import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/main_screen.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/providers/song_provider.dart';
import 'package:TuneFlow/screens/library_screen.dart';
import 'package:TuneFlow/screens/search_screen.dart';
import 'package:TuneFlow/widgets/player_bottom.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Widget plBottom = Container();

    final songPlayRun = ref.watch(songProvider);
    for (Song st in songPlayRun) {
      if (st.isRunning) {
        plBottom = PlayerBottom(song: st);
      }
    }

    Widget activeWidget = MainScreen();

    if (_currentPage == 1) {
      activeWidget = SearchScreen();
    }
    if (_currentPage == 2) {
      activeWidget = LibraryScreen();
    }
    return Scaffold(
      body: activeWidget,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          plBottom,
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color.fromARGB(255, 159, 172, 206),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.black.withOpacity(0.1),
            elevation: 0,
            currentIndex: _currentPage,
            onTap: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: "Search"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_add), label: "Library")
            ],
          ),
        ],
      ),
    );
  }
}
