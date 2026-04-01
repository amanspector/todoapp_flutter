import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/homepage.dart';
import 'package:todoapp/splashScreen.dart';
import 'package:todoapp/text_for_the_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/todoTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await SharedPrefFile.initpref();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: TextForTheApp.todoapptitle,
      themeMode: ThemeMode.system,
      theme: Todotheme.lightThmem,
      darkTheme: Todotheme.darktheme,
      home: Splashscreen(),
    );
  }
}
