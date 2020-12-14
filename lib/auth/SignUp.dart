import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localregex/localregex.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_app/api/api.dart';
import 'package:token_app/models/user.dart';
import 'package:token_app/pages/home.dart';
import 'package:token_app/utils/Colors.dart';
import 'package:token_app/utils/Constant.dart';
import 'package:token_app/utils/Extension.dart';
import 'package:token_app/utils/Strings.dart';
import 'package:token_app/utils/Widget.dart';

import 'SignIn.dart';

class SignUp extends StatefulWidget {
  static String tag = '/T10SignUp';

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController number = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController cpassword = new TextEditingController();
  String _error = "";
  final localregex = LocalRegex();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    changeStatusColor(t10_white);
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Connecting to server...."), title: Text("Please wait"));
    return Scaffold(
      backgroundColor: t10_white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: t10_white,
            margin: EdgeInsets.only(left: spacing_large, right: spacing_large),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/logo.png",
                  height: 65.0,
                  width: 65.0,
                ),
                text(theme10_lbl_register,
                    fontFamily: fontBold, fontSize: textSizeXLarge),
                SizedBox(
                  height: spacing_large,
                ),
                EditText(
                  text: "Full Name",
                  isPassword: false,
                  mController: name,
                ),
                SizedBox(
                  height: spacing_standard_new,
                ),
                EditText(
                  text: theme10_email,
                  isPassword: false,
                  mController: email,
                ),
                SizedBox(
                  height: spacing_standard_new,
                ),
                EditText(
                  text: "Phone Number",
                  isPassword: false,
                  mController: number,
                ),
                SizedBox(
                  height: spacing_standard_new,
                ),
                EditText(
                  text: theme10_password,
                  isSecure: true,
                  mController: password,
                ),
                SizedBox(
                  height: spacing_standard_new,
                ),
                EditText(
                  text: theme10_confirm_password,
                  isSecure: true,
                  mController: cpassword,
                ),
                SizedBox(
                  height: spacing_xlarge,
                ),
                Text(
                  _error,
                  style:
                      TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 10.0,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: 0.0,
                      ),
                SizedBox(
                  height: 10.0,
                ),
                AppButton(
                  onPressed: () {
                    if (name.text != "" &&
                        email.text != "" &&
                        number.text != "" &&
                        password.text != "" &&
                        cpassword.text != "") {
                      setState(() {
                        _isLoading = true;
                        progressDialog.show();
                      });

                      if (localregex.isZwMobile(number.text)) {
                        if (password.text.trim() == cpassword.text.trim()) {
                          if (localregex.isEmail(email.text)) {
                            setState(() {
                              _error = "";
                            });
                            API
                                .register(name.text, email.text, number.text,
                                    password.text, cpassword.text)
                                .then((response) {
                              try {
                                User user =
                                    User.fromJson(json.decode(response.body));
                                saveUserPrefs(user, context);
                              } on FormatException catch (e) {
                                print('error caught: $e');
                                setState(() {
                                  _isLoading = false;
                                  _error = "Server error. Try again";
                                });
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = false;
                              _error = "Invalid email address";
                            });
                          }
                        } else {
                          setState(() {
                            _isLoading = false;
                            _error = "Password Mismatch.";
                          });
                        }
                      } else {
                        setState(() {
                          _isLoading = false;
                          _error = "Invalid phone number";
                        });
                      }
                    } else {
                      setState(() {
                        _isLoading = false;
                        _error = "No empty fields allowed";
                      });
                    }
                    progressDialog.dismiss();
                  },
                  textContent: theme10_lbl_register,
                ),
                SizedBox(
                  height: spacing_large,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    text(theme10_lbl_already_have_account,
                        textColor: t10_textColorSecondary,
                        fontFamily: fontMedium),
                    SizedBox(
                      width: spacing_control,
                    ),
                    GestureDetector(
                      child: text(theme10_lbl_sign_in, fontFamily: fontMedium),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //save the user preferences
  saveUserPrefs(User userModel, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = userModel.toMap();
    await prefs.setInt('id', map["id"]);
    await prefs.setString('name', map["name"]);
    await prefs.setString('email', map["email"]);
    await prefs.setString('number', map["number"]);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
