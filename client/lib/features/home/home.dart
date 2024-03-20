import 'package:flutter/material.dart';
import 'package:gemini/features/home/model/question.model.dart';
import 'package:gemini/features/home/widget.dart';
import 'package:gemini/service/api_service.dart';
import 'package:gemini/utils/constant.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Home extends StatefulWidget {
  String token;
  Home({super.key, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Map<String, dynamic> jwtDecodedToken;
  late Future<List<QuestionItem>> qns;
  var user_name;
  var email;
  void initState() {
    print(widget.token);
    super.initState();
    jwtDecodedToken = JwtDecoder.decode(widget.token);
    user_name = jwtDecodedToken['name'];
    email = jwtDecodedToken['email'];
    // getData();
    qns = ApiService().get_Question(email);
    print(user_name);
    print(email);
  }

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
      drawer: HomeDrawer(qns, context, user_name, email),
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
