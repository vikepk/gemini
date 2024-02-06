import 'package:flutter/material.dart';
import 'package:gemini/features/getstarted/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
//declared and intialised in main dart so can be used in all files as import
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}
