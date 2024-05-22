import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/features/home/model/answer_model.dart';
import 'package:gemini/features/home/model/question.model.dart';
import 'package:gemini/features/home/widget.dart';
import 'package:gemini/service/api_service.dart';
import 'package:gemini/utils/constant.dart';
import 'package:gemini/utils/notifymessage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Home extends StatefulWidget {
  String token;
  Home({super.key, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _imagepath = '';
  final ImagePicker imgpicker = ImagePicker();
  Future getImage(bool isCamera) async {
    List<String> allowedExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.heic',
      '.heif'
    ];
    try {
      var pickedFile = await imgpicker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        String fileExt = path.extension(pickedFile.path);
        if (allowedExtensions.contains(fileExt)) {
          print('File extension $fileExt is allowed.');
          setState(() {
            _imagepath = pickedFile.path;
          });
          // Proceed with further processing
        } else {
          print('File extension $fileExt is not allowed.');
          // Handle error or other actions
          NotifyUserMessage()
              .errMessage(context, "Image File format not Supported");
        }
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking image.${e.toString()}");
    }
  }

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
            _textController.text = textString;
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

  final ApiService _apiService = ApiService();
  late Map<String, dynamic> jwtDecodedToken;
  late Future<List<QuestionItem>> qns;
  final List<Widget> _messages = [];
  final TextEditingController _textController = TextEditingController();
  var user_name;
  bool _isloading = false;
  var email;
  @override
  void initState() {
    print(widget.token);
    super.initState();
    jwtDecodedToken = JwtDecoder.decode(widget.token);
    user_name = jwtDecodedToken['name'];
    email = jwtDecodedToken['email'];

    qns = ApiService().get_Question(email);

    speech = speechToText.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    void _textRequest(String qn) async {
      setState(() {
        _messages.add(MsgBubble(
            isMe: true, text: qn, user: "You", isloading: false, imgpath: ""));
        _messages.add(MsgBubble(
          isMe: false,
          text: qn,
          user: "Gemini",
          isloading: true,
          imgpath: "",
        ));
        _textController.text = "LOADING";
        _isloading = true;
      });

      Answer textAns = await _apiService.text_Request(email, qn);
      print(textAns.answer);
      setState(() {
        _messages.removeLast();
        _messages.add(MsgBubble(
          isMe: false,
          text: textAns.answer,
          user: "Gemini",
          isloading: false,
          imgpath: "",
        ));
        _textController.clear();
        _isloading = false;
      });
      // Send message to backend or handle message receiving logic
    }

    void _textToRequest(String qn, String imgpath, String ans) async {
      setState(() {
        _messages.add(MsgBubble(
            isMe: true,
            text: qn,
            user: "You",
            isloading: false,
            imgpath: imgpath));
      });

      setState(() {
        _messages.add(MsgBubble(
          isMe: false,
          text: ans,
          user: "Gemini",
          isloading: false,
          imgpath: "",
        ));
        _textController.clear();
      });
      // Send message to backend or handle message receiving logic
    }

    void _imageRequest() async {
      bool _isloading = false;
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) => Dialog(
                  child: _isloading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: KGreen,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.all(20),
                          height: AppQuery.ScreenHeight(context) * 0.25,
                          width: AppQuery.ScreenWidth(context) * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _imagepath.isNotEmpty
                                  ? Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Image(
                                          filterQuality: FilterQuality.high,
                                          height:
                                              AppQuery.ScreenHeight(context) *
                                                  0.18,
                                          width: AppQuery.ScreenWidth(context) *
                                              0.55,
                                          image: FileImage(
                                            File(_imagepath),
                                          ),
                                        ),
                                        Positioned(
                                          bottom:
                                              AppQuery.ScreenHeight(context) *
                                                  0.129,
                                          left: AppQuery.ScreenWidth(context) *
                                              0.18,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _imagepath = "";
                                                  _textController.text = "";
                                                });
                                              },
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.black,
                                              )),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        imageUpload("Camera", () async {
                                          await getImage(true);
                                          setState(() {});
                                        }, Icons.camera),
                                        imageUpload("Gallery", () async {
                                          await getImage(false);
                                          setState(() {});
                                        }, Icons.upload_file_rounded),
                                      ],
                                    ),
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                      hintText: "Enter Prompt",
                                      suffix: IconButton(
                                          onPressed: () async {
                                            setState(() => _isloading = true);
                                            Answer ans =
                                                await _apiService.img_Request(
                                                    email,
                                                    _textController.text,
                                                    _imagepath);
                                            setState(() => _isloading = false);
                                            print(ans.answer);
                                            _textToRequest(_textController.text,
                                                _imagepath, ans.answer!);
                                            _imagepath = "";
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.send))),
                                ),
                              )
                            ],
                          ),
                        )),
            );
          });
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
                return _messages[index];
                // Customize appearance for incoming and outgoing messages
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
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: TextFormField(
                      controller: _textController,

                      decoration: InputDecoration(
                        labelText: 'Enter Prompt',
                        suffix: _isloading
                            ? CircularProgressIndicator(
                                color: KGreen,
                                strokeWidth: 2,
                              )
                            : null,
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
                      ),
                      style: KBody1,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      // validator: (value) => validatePhoneNumber(value!),
                    ),
                  ),
                ),
                AvatarGlow(
                  animate: isListen,
                  glowColor: KGreen,
                  glowShape: BoxShape.circle,
                  duration: Duration(milliseconds: 1000),
                  glowRadiusFactor: 1,
                  repeat: true,
                  child: IconButton(
                    icon: Icon(isListen ? Icons.mic : Icons.mic_none),
                    onPressed: () {
                      listen();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.image_rounded),
                  onPressed: () {
                    _imageRequest();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty &&
                        !(_textController.text == "LOADING")) {
                      _textRequest(_textController.text);
                    } else {
                      NotifyUserMessage().errMessage(context, "Enter Prompt");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
