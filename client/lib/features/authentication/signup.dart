import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gemini/features/authentication/login.dart';
import 'package:gemini/service/api_service.dart';
import 'package:gemini/utils/notifymessage.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController phoneNumber = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirmpassword = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    void signUp() async {
      await ApiService().sign_up(
          context, name.text, email.text, password.text, phoneNumber.text);
    }

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
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
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
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    // FadeInUp(
                    //     duration: Duration(milliseconds: 1200),
                    //     child: Text(
                    //       "Create an account, It's free",
                    //       style:
                    //           TextStyle(fontSize: 15, color: Colors.grey[700]),
                    //     )),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: makeInput(
                            label: "Name", value: name, val_Msg: 'Name')),
                    FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: makeInput(
                            label: "Email", value: email, val_Msg: 'Email')),
                    FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: makeInput(
                            label: "Phone Number",
                            value: phoneNumber,
                            val_Msg: 'Phone Number')),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: makeInput(
                            label: "Password",
                            obscureText: true,
                            value: password,
                            val_Msg: 'Password')),
                    FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: makeInput(
                            label: "Confirm Password",
                            obscureText: true,
                            value: confirmpassword,
                            val_Msg: 'Confirm Password')),
                  ],
                ),
                FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (password.text == confirmpassword.text) {
                              signUp();
                            } else {
                              NotifyUserMessage.notifyType(
                                  context, "Password doesn't Match");
                            }
                          }
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    )),
                FadeInUp(
                    duration: Duration(milliseconds: 1600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?"),
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

  Widget makeInput(
      {label,
      obscureText = false,
      TextEditingController? value,
      required String val_Msg}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: value,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: val_Msg,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                )),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ' + val_Msg;
            }
            return null;
          },
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
