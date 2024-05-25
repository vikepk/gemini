import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';
import 'package:gemini/features/gemini/presentation/widgets/button.dart';
import 'package:gemini/features/gemini/presentation/widgets/home_drawer.dart';
import 'package:gemini/features/gemini/presentation/widgets/img_upload.dart';
import 'package:gemini/features/gemini/presentation/widgets/msg_bubble.dart';
import 'package:gemini/features/gemini/presentation/widgets/prompt_textfield.dart';

import 'package:gemini/main.dart';
import 'package:gemini/service/api_service.dart';
import 'package:gemini/utils/notifymessage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
  // late Future<List<QuestionItemEntity>> qns;
  final List<Widget> _messages = [];
  final TextEditingController _textController = TextEditingController();
  String? token;
  String? user_name;
  bool _isloading = false;
  String? user_email;
  @override
  void initState() {
    super.initState();
    token = prefs.getString(ktoken)!;
    jwtDecodedToken = JwtDecoder.decode(token!);
    user_name = jwtDecodedToken['name']!;
    user_email = jwtDecodedToken['email']!;

    speech = speechToText.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    // final qns=ref.read(geminiQuestionsProvider(UserEntity(email: user_email)));
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

      AnswerEntity textAns = await _apiService.text_Request(user_email!, qn);
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
                                            AnswerEntity ans =
                                                await _apiService.img_Request(
                                                    user_email!,
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
      drawer: HomeDrawer(email: user_email!, name: user_name!),
      appBar: AppBar(
        backgroundColor: KGreen,
        centerTitle: true,
        title: Text("Gemini Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text("data"),
                  )
                : ListView.builder(
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
                PromptTextfield(
                  value: _textController,
                  isloading: false,
                ),
                VoiceButton(isloading: false, callback: listen),
                BottomButton(
                    callback: () => _imageRequest(),
                    iconData: Icons.image_rounded),
                BottomButton(
                    callback: () {
                      if (_textController.text.isNotEmpty &&
                          !(_textController.text == "LOADING")) {
                        _textRequest(_textController.text);
                      } else {
                        NotifyUserMessage().errMessage(context, "Enter Prompt");
                      }
                    },
                    iconData: Icons.send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
