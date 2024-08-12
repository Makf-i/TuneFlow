import 'package:TuneFlow/screens/library_screen.dart';
import 'package:TuneFlow/screens/liked_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//This StateNotifier  manages a single Widget , likedScreen
class ScreenProviderNotifier extends StateNotifier<Widget> {
  ScreenProviderNotifier() : super(const LibraryScreen());
  //the above statement is an intializer for the screenprovidernotifier, that is
  //initial state should be LubraryScreen and when the goToLikedScreen function is called
  //that initializer is replaced with LikedScreen or the state is changed from Library to Liked

  void gotToLikedScreen(likeSng) {
    state = const LikedScreen();
  }

  void goToLibraryScreen() {
    state = const LibraryScreen();
  }
}

final screenProvider = StateNotifierProvider<ScreenProviderNotifier, Widget>(
  (ref) => ScreenProviderNotifier(),
);
