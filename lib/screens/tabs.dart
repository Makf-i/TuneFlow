import 'package:TuneFlow/providers/screen_provider.dart';
import 'package:TuneFlow/providers/song_manager.dart';
import 'package:TuneFlow/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/main_screen.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/screens/search_screen.dart';
import 'package:TuneFlow/widgets/player_bottom.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();
List<Song> allAvailableSongs = [];

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _currentPage = 0;
  Widget? activeWidget;

  List<String> _audioUrlStorage = [];
  List<String> _audioNamesStorage = [];
  List<String> _title = [];
  List<String> _artist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _availableSongsUrl(); // Fetch audio URLs
    await _songNames(); // Fetch audio names

    List<String> titleList = [];
    List<String> artistList = [];

    for (String track in _audioNamesStorage) {
      List<String> parts = track.split(' - ');
      if (parts.length == 2) {
        String title = parts[0].trim();
        String songName = parts[1].replaceAll(RegExp(r'\.mp3$'), '').trim();

        artistList.add(title);
        titleList.add(songName);
      }
    }
    setState(() {
      _title = titleList;
      _artist = artistList;
      _isLoading = false; // Set loading to false after data is loaded
    });

    for (int i = 0; i < _audioUrlStorage.length; i++) {
      allAvailableSongs.add(Song(
        id: uid.v4(),
        location: _audioUrlStorage[i],
        name: _title[i],
        artist: _artist[i],
      ));
    }

    // Load songs into the song provider
    //since loadSongs becomes a future we give await
    await ref.read(songProvider.notifier).loadSongs(allAvailableSongs);
  }

  Future<void> _availableSongsUrl() async {
    final songStorage = FirebaseStorage.instance;
    ListResult result =
        await songStorage.ref().child('availableSongs').listAll();

    List<String> audioUrl = [];
    for (Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      audioUrl.add(url);
    }
    setState(() {
      _audioUrlStorage = audioUrl;
    });
  }

  Future<void> _songNames() async {
    final storage = FirebaseStorage.instance;
    ListResult result = await storage.ref('availableSongs').listAll();

    List<String> songNames = [];
    for (Reference ref in result.items) {
      songNames.add(ref.name);
    }
    setState(() {
      _audioNamesStorage = songNames;
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Add cleanup code here
  }

  @override
  Widget build(BuildContext context) {
    final whatLibraryScrn = ref.watch(screenProvider);

    return Scaffold(
      //A Stack that shows a single child from a list of children.
      body: _isLoading
          ? const SplashScreen()
          : IndexedStack(
              index: _currentPage,
              children: [
                const MainScreen(),
                const SearchScreen(),
                whatLibraryScrn,
              ],
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PlayerBottom(),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color.fromARGB(255, 159, 172, 206),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.black.withOpacity(0.1),
            elevation: 0,
            currentIndex: _currentPage,
            onTap: (index) {
              setState(() {
                _currentPage = index;
                if (index == 2) {
                  ref.read(screenProvider.notifier).goToLibraryScreen();
                }
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
