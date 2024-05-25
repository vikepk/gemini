import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:speech_to_text/speech_to_text.dart' as speechToText;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late speechToText.SpeechToText speech;

  bool isListen = false;

  void listen() async {
    if (!isListen) {
      bool avail = await speech.initialize();
      if (avail) {
        setState(() {
          isListen = true;
        });
        speech.listen(onResult: (value) {
          setState(() {
            String textString = value.recognizedWords;
          });
        });
      }
    } else {
      setState(() {
        isListen = false;
      });
      speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    speech = speechToText.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech To Text"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
      floatingActionButton: AvatarGlow(
        animate: isListen,
        glowColor: Colors.red,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          child: Icon(isListen ? Icons.mic : Icons.mic_none),
          onPressed: () {
            listen();
          },
        ),
      ),
    );
  }
}
