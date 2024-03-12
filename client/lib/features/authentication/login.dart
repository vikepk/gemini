// ignore_for_file: use_key_in_widget_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gemini/features/authentication/signup.dart';
import 'package:gemini/features/home/home.dart';
import 'package:gemini/service/api_service.dart';
import 'package:gemini/utils/constant.dart';
import 'package:gemini/utils/notifymessage.dart';

class LoginPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void signIn(email, password) async {
      await ApiService().sign_in(context, email, password);
    }

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
                        FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Text(
                              "Login to your account",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: "Email"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: TextFormField(
                              controller: password,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "Password"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: const Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
                            // Login Button
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  signIn(email.text, password.text);
                                }

                                //Have to call after validation
                              },
                              color: KGreen,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                          ),
                        )),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Don't have an account?"),
                            // signup login
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupPage()));
                              },
                              child: const Text("Sign up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            // FadeInUp(
            //     duration: const Duration(milliseconds: 1200),
            //     child: Container(
            //       height: MediaQuery.of(context).size.height / 3,
            //       decoration: const BoxDecoration(
            //           image: DecorationImage(
            //               image: AssetImage('assets/background.png'),
            //               fit: BoxFit.cover)),
            //     ))
          ],
        ),
      ),
    );
  }
  // not required
  // Widget makeInput(
  //     {label, obscureText = false, required TextEditingController value}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text(
  //         label,
  //         style: const TextStyle(
  //             fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
  //       ),
  //       const SizedBox(
  //         height: 5,
  //       ),
  //       TextField(
  //         controller: value,
  //         obscureText: obscureText,
  //         decoration: InputDecoration(
  //           contentPadding:
  //               const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  //           enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.grey.shade400)),
  //           border: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.grey.shade400)),
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 30,
  //       ),
  //     ],
  //   );
  // }
}
