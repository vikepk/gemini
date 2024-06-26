import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';
import 'package:gemini/features/authentication/presentation/pages/login.dart';
import 'package:gemini/features/authentication/presentation/providers/authetication_provider.dart';
import 'package:gemini/features/authentication/presentation/widgets/signButton.dart';
import 'package:gemini/utils/notifymessage.dart';

import '../widgets/textfield_widget.dart';

class SignupPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController phoneNumber = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirmpassword = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final state = ref.watch(AuthControllerProvider);

    ref.listen<AsyncValue>(
      AuthControllerProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          NotifyUserMessage.notifyType(
              context, state.error.toString().replaceFirst('Exception:', ''));
        } else if (state.asData != null) {
          NotifyUserMessage.notifyType(context, state.value);
          Navigator.of(context).pop();
        }
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          // height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Sign up",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    makeInput(label: "Name", value: name, val_Msg: 'Name'),
                    makeInput(label: "Email", value: email, val_Msg: 'Email'),
                    makeInput(
                        label: "Phone Number",
                        value: phoneNumber,
                        val_Msg: 'Phone Number'),
                    makeInput(
                        label: "Password",
                        obscureText: true,
                        value: password,
                        val_Msg: 'Password'),
                    makeInput(
                        label: "Confirm Password",
                        obscureText: true,
                        value: confirmpassword,
                        val_Msg: 'Confirm Password'),
                  ],
                ),
                signButton(
                    widget: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                    callback: () async {
                      if (_formKey.currentState!.validate()) {
                        if (password.text == confirmpassword.text) {
                          state.isLoading
                              ? null
                              : ref
                                  .read(AuthControllerProvider.notifier)
                                  .signUp(UserEntity(
                                      name: name.text,
                                      email: email.text,
                                      phonenumber: phoneNumber.text,
                                      password: password.text));
                        } else {
                          NotifyUserMessage.notifyType(
                              context, "Password doesn't Match");
                        }
                      }
                    }),
                FadeInUp(
                    duration: const Duration(milliseconds: 1600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: const Text("Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
