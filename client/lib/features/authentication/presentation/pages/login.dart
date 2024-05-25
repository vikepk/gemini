import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/authentication/presentation/pages/signup.dart';
import 'package:gemini/features/authentication/presentation/providers/authetication_provider.dart';
import 'package:gemini/features/authentication/presentation/widgets/signButton.dart';
import 'package:gemini/features/authentication/presentation/widgets/textfield_widget.dart';
import 'package:gemini/features/gemini/presentation/pages/home.dart';
import 'package:gemini/utils/notifymessage.dart';

class LoginPage extends ConsumerWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(AuthControllerProvider);

    ref.listen<AsyncValue>(
      AuthControllerProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    state.error.toString().replaceFirst('Exception:', ''))),
          );
        } else if (state.asData != null) {
          NotifyUserMessage.notifyType(context, state.value);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Home()),
              (route) => false);
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          makeInput(
                            label: "Email",
                            obscureText: false,
                            value: email,
                            val_Msg: 'Email',
                          ),
                          const SizedBox(height: 20),
                          makeInput(
                            label: "Password",
                            obscureText: true,
                            value: password,
                            val_Msg: 'Password',
                          ),
                        ],
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return signButton(
                            widget: state.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                            callback: () {
                              if (_formKey.currentState!.validate()) {
                                state.isLoading
                                    ? null
                                    : ref
                                        .read(AuthControllerProvider.notifier)
                                        .signIn(
                                          UserEntity(
                                            email: email.text,
                                            password: password.text,
                                          ),
                                        );
                              }
                            });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
