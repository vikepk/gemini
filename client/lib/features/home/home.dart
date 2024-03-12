import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/utils/constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();
    List<String> _messages = [];

    void _handleSubmitted(String text) {
      setState(() {
        _messages.add(text);
      });
      _textController.clear();
      // Send message to backend or handle message receiving logic
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Chats',
                style: KTitle1,
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: KGreen,
        centerTitle: true,
        title: Text("Gemini Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_messages[index]),
                  // Customize appearance for incoming and outgoing messages
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: TextFormField(
                      // controller: _model.phoneNumber,
                      decoration: InputDecoration(
                        labelText: 'Enter Prompt',
                        labelStyle: KBody1,
                        hintStyle: KBody1,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: KGreen,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: KGreen,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      style: KBody1,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      // validator: (value) => validatePhoneNumber(value!),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
                IconButton(
                  icon: Icon(Icons.image_rounded),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
