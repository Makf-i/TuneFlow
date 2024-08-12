import 'package:TuneFlow/providers/song_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:TuneFlow/screens/splash.dart';
import 'package:TuneFlow/widgets/audiomanager.dart';
import 'package:TuneFlow/widgets/song_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() {
    return _MainScreenState(); // Corrected from _MainScreenSate to _MainScreenState
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final songIs = ref.watch(songProvider);
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
      body: songIs.isEmpty
          ? const SplashScreen()
          : ListView.builder(
              itemCount: songIs.length,
              itemBuilder: (context, index) {
                return SongButton(
                  song: songIs[index],
                  id: songIs[index].id,
                );
              },
            ),
    );
  }
}
