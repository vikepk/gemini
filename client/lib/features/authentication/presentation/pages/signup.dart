import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gemini/features/authentication/Login.dart';
import 'package:gemini/features/authentication/presentation/widgets/signButton.dart';
import 'package:gemini/utils/notifymessage.dart';

import '../widgets/textfield_widget.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController phoneNumber = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirmpassword = TextEditingController();
    final _formKey = GlobalKey<FormState>();

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
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: makeInput(
                            label: "Name", value: name, val_Msg: 'Name')),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: makeInput(
                            label: "Email", value: email, val_Msg: 'Email')),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: makeInput(
                            label: "Phone Number",
                            value: phoneNumber,
                            val_Msg: 'Phone Number')),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: makeInput(
                          label: "Password",
                          obscureText: true,
                          value: password,
                          val_Msg: 'Password'),
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: makeInput(
                            label: "Confirm Password",
                            obscureText: true,
                            value: confirmpassword,
                            val_Msg: 'Confirm Password')),
                  ],
                ),
                signButton(
                    text: "Sign Up",
                    callback: () async {
                      if (_formKey.currentState!.validate()) {
                        if (password.text == confirmpassword.text) {
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
