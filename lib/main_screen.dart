import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:TuneFlow/screens/splash.dart';
import 'package:TuneFlow/widgets/audiomanager.dart';
import 'package:TuneFlow/widgets/song_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/providers/song_provider.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();
List<Song> allAvailableSongs = [];

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  ConsumerState<MainScreen> createState() {
    return _MainScreenState(); // Corrected from _MainScreenSate to _MainScreenState
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
    ref.read(songProvider.notifier).loadSongs(allAvailableSongs);
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
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final songIs = ref.watch(songProvider);
    bool color = songIs.any((sng) => sng.isRunning);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TuneFlow'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await AudioManager().stop();
            },
          ),
        ],
      ),
      drawer: const Drawer(),
      body: _isLoading
          ? const SplashScreen()
          : ListView.builder(
              itemCount: _audioUrlStorage.length,
              itemBuilder: (context, index) {
                return SongButton(
                  song: songIs[index],
                );
              },
            ),
    );
  }
}
