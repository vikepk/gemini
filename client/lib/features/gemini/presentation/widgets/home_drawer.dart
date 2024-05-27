import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/authentication/presentation/pages/login.dart';
import 'package:gemini/features/gemini/presentation/providers/gemini_provider.dart';
import 'package:gemini/main.dart';
import 'package:gemini/utils/notifymessage.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  final String email;
  final String name;

  HomeDrawer({required this.email, required this.name});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(GeminiQnControllerProvider.notifier)
          .getQuestions(user: UserEntity(email: widget.email));
    });
  }

  @override
  Widget build(BuildContext context) {
    void _logOut() async {
      await prefs.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (route) => false);
    }

    final state = ref.watch(GeminiQnControllerProvider);

    ref.listen<AsyncValue>(
      GeminiQnControllerProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          NotifyUserMessage.notifyType(
              context, state.error.toString().replaceFirst('Exception:', ''));
        }
      },
    );

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Chats",
                        style: KTitle1,
                      ),
                      TextButton(
                          onPressed: () async {
                            _logOut();
                          },
                          child: Row(
                            children: [
                              Text(
                                'Logout',
                                style: KBody1.copyWith(color: KBlack),
                              ),
                              const Icon(
                                Icons.logout,
                                color: KBlack,
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset("assets/images/profile.png"),
                      radius: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: KTitle2,
                        ),
                        Text(
                          widget.email,
                          style: KBody1,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          state.when(
            data: (questions) {
              return questions.isEmpty
                  ? Center(
                      child: Text(
                      'No questions found',
                      style: KBody1.copyWith(color: KWhite),
                    ))
                  : Column(
                      children: questions.map((qn) {
                        return ListTile(
                          title: Text(
                            qn.question,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // Do something with the tapped item
                          },
                        );
                      }).toList(),
                    );
            },
            error: (error, stackTrace) => Center(
              child: TextButton(
                onPressed: () {
                  ref.invalidate(GeminiQnControllerProvider);
                },
                child: Text(
                  error is DioException ? "Network Error" : error.toString(),
                ),
              ),
            ),
            loading: () => const Center(
                child: CircularProgressIndicator(
              color: KGreen,
            )),
          ),
        ],
      ),
    );
  }
}
