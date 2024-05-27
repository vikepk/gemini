import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';
import 'package:gemini/features/gemini/presentation/providers/gemini_provider.dart';
import 'package:gemini/features/gemini/presentation/providers/loading_provider.dart';
import 'package:gemini/features/gemini/presentation/providers/message_provider.dart';
import 'package:gemini/features/gemini/presentation/widgets/button.dart';
import 'package:gemini/features/gemini/presentation/widgets/home_drawer.dart';
import 'package:gemini/features/gemini/presentation/widgets/img_upload.dart';
import 'package:gemini/features/gemini/presentation/widgets/invite.dart';
import 'package:gemini/features/gemini/presentation/widgets/msg_bubble.dart';
import 'package:gemini/features/gemini/presentation/widgets/prompt_textfield.dart';
import 'package:gemini/main.dart';
import 'package:gemini/utils/notifymessage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
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
        } else {
          print('File extension $fileExt is not allowed.');

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

  late Map<String, dynamic> jwtDecodedToken;

  final TextEditingController _textController = TextEditingController();
  String? token;
  String? user_name;

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
    final isloading = ref.watch(loadingStateProvider);
    final messageNotifier = ref.read(MessageNotifierProvider.notifier);
    final messages = ref.watch(MessageNotifierProvider);
    final loadingNotifier = ref.read(loadingStateProvider.notifier);
    final geminiAnsNotifier = ref.read(GeminiAnsControllerProvider.notifier);
    final geminiImgNotifier = ref.read(GeminiImgControllerProvider.notifier);

    void _textRequest(String qn) async {
      messageNotifier.addMessage(MsgBubble(
          isMe: true, text: qn, user: "You", isloading: false, imgpath: ""));

      messageNotifier.addMessage(MsgBubble(
        isMe: false,
        text: qn,
        user: "Gemini",
        isloading: true,
        imgpath: "",
      ));

      _textController.text = "LOADING";

      loadingNotifier.state = true;

      try {
        await geminiAnsNotifier.textReq(
          user: UserEntity(email: user_email),
          qn: QuestionItemEntity(question: qn),
        );

        final geminiAns = ref.read(GeminiAnsControllerProvider);

        geminiAns.when(
          data: (ans) {
            messageNotifier.deleteMessage();

            messageNotifier.addMessage(MsgBubble(
              isMe: false,
              text: ans.answer,
              user: "Gemini",
              isloading: false,
              imgpath: "",
            ));
          },
          error: (error, stack) {
            NotifyUserMessage().errMessage(context, 'Try Again Later');
          },
          loading: () {},
        );
      } catch (error) {
        // Handle any unexpected errors
        NotifyUserMessage().errMessage(context, 'Unexpected Error Occurred');
      } finally {
        _textController.clear();
        loadingNotifier.state = false;
      }
    }

    void listen() async {
      if (!isloading) {
        bool avail = await speech.initialize();
        if (avail) {
          ref.read(loadingStateProvider.notifier).startLoading();

          speech.listen(onResult: (value) {
            String textString = value.recognizedWords;
            _textController.text = textString;
          });
        }
      } else {
        ref.read(loadingStateProvider.notifier).stopLoading();

        speech.stop();
      }
    }

    void _textToRequest(String qn, String imgpath, String ans) async {
      messages.add(MsgBubble(
          isMe: true,
          text: qn,
          user: "You",
          isloading: false,
          imgpath: imgpath));

      messages.add(MsgBubble(
        isMe: false,
        text: ans,
        user: "Gemini",
        isloading: false,
        imgpath: "",
      ));
      _textController.clear();
    }

    void _imageRequest() async {
      final isloading = ref.read(loadingStateProvider.notifier);

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Dialog(
              child: Container(
                margin: const EdgeInsets.all(20),
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
                                height: AppQuery.ScreenHeight(context) * 0.18,
                                width: AppQuery.ScreenWidth(context) * 0.55,
                                image: FileImage(
                                  File(_imagepath),
                                ),
                              ),
                              Positioned(
                                bottom: AppQuery.ScreenHeight(context) * 0.129,
                                left: AppQuery.ScreenWidth(context) * 0.18,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _imagepath = "";
                                      _textController.text = "";
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              isloading.startLoading();
                              try {
                                // Perform the text request
                                await geminiImgNotifier.imgReq(
                                    user: UserEntity(email: user_email),
                                    qn: QuestionItemEntity(
                                        question: _textController.text),
                                    imgPath: _imagepath);

                                final geminiImg =
                                    ref.read(GeminiImgControllerProvider);

                                geminiImg.when(
                                  data: (ans) {
                                    messages.add(MsgBubble(
                                        isMe: true,
                                        text: _textController.text,
                                        user: "You",
                                        isloading: false,
                                        imgpath: _imagepath));

                                    messages.add(MsgBubble(
                                      isMe: false,
                                      text: ans.answer,
                                      user: "Gemini",
                                      isloading: false,
                                      imgpath: "",
                                    ));
                                  },
                                  error: (error, stack) {
                                    NotifyUserMessage()
                                        .errMessage(context, 'Try Again Later');
                                  },
                                  loading: () {},
                                );
                              } catch (error) {
                                // Handle any unexpected errors
                                NotifyUserMessage().errMessage(
                                    context, 'Unexpected Error Occurred');
                              } finally {
                                _textController.clear();
                                loadingNotifier.state = false;
                              }

                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: KBackground,
      extendBodyBehindAppBar: true,
      drawer: HomeDrawer(email: user_email!, name: user_name!),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: KGreen),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Lottie.asset("assets/lottie/gemini.json", height: 100),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: messages.isEmpty
                ? const Invite()
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return messages[index];
                      // Customize appearance for incoming and outgoing messages
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PromptTextfield(
                value: _textController,
                isloading: isloading,
              ),
              VoiceButton(isloading: isloading, callback: listen),
              BottomButton(
                  callback: () => _imageRequest(),
                  iconData: Icons.image_rounded),
              BottomButton(
                  callback: () {
                    if (_textController.text.isNotEmpty && !(isloading)) {
                      _textRequest(_textController.text);
                    } else {
                      NotifyUserMessage().errMessage(
                          context, isloading ? "Loading" : "Enter Prompt");
                    }
                  },
                  iconData: Icons.send),
            ],
          ),
        ],
      ),
    );
  }
}
