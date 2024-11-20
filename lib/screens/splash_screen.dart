import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:green_aid/screens/login_screen.dart';

import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key, required this.camera});
  final CameraDescription camera;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/logo_white.png',
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      duration: 1500,
      nextScreen: LoginScreen(camera: camera),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}