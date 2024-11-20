import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_aid/firebase_options.dart';
import 'package:green_aid/screens/splash_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async { 

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));

  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color.fromRGBO(52, 190, 73, 1),
          secondary: Color.fromRGBO(232, 245, 233, 1)
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(46, 125, 50, 1),
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(46, 125, 50, 1),
          )
        )
      ),
      title: "Green Aid",
      debugShowCheckedModeBanner: false,
      home: Splashscreen(camera: firstCamera),
    ),
  );
}