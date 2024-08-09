import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

//just loading screen just to show so that not the authscreen is shown
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        height: 300,
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFFEA3799),
          size: 40,
        ),
      ),
    ));
  }
}
