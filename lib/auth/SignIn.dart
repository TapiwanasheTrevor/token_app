import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localregex/localregex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_app/api/api.dart';
import 'package:token_app/models/user.dart';
import 'package:token_app/pages/home.dart';
import 'package:token_app/utils/Colors.dart';
import 'package:token_app/utils/Constant.dart';
import 'package:token_app/utils/Extension.dart';
import 'package:token_app/utils/Strings.dart';
import 'package:token_app/utils/Widget.dart';

import 'SignUp.dart';

class SignIn extends StatefulWidget {
  static String tag = '/T10SignIn';

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _requesting = false;
  bool _haserror = false;
 final localregex = LocalRegex();
 
  @override
  Widget build(BuildContext context) {
    changeStatusColor(t10_white);

    return Scaffold(
      backgroundColor: t10_white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: t10_white,
          margin: EdgeInsets.only(left: spacing_large, right: spacing_large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: 65.0,
                width: 65.0,
              ),
              text(theme10_lbl_welcome,
                  fontFamily: fontBold, fontSize: textSizeXLarge),
              SizedBox(
                height: spacing_large,
              ),
              EditText(
                text: "Email",
                isPassword: false,
                mController: email,
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
                height: 10,
              ),
              _haserror
                  ? Text(
                      "Invalid Credentials",
                      style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              SizedBox(
                height: spacing_xlarge,
              ),
              AppButton(
                onPressed: () {
                  setState(() {
                    _requesting = true;
                  });
                  if (email.text != "" && password.text != "") {
                    
                    API.login(email.text, password.text).then((response) {
                      User user = User.fromJson(json.decode(response.body));
                      if (user.id != null) {
                        saveUserPrefs(user, context);
                      } else {
                        setState(() {
                          _haserror = true;
                          _requesting = false;
                        });
                      }
                    });


                  } else {
                    setState(() {
                      _haserror = true;
                      _requesting = false;
                    });
                  }
                },
                textContent: theme10_lbl_sign_in,
              ),
              SizedBox(
                height: spacing_large,
              ),
              text(theme10_lbl_forget_pswd,
                  textColor: t10_textColorSecondary, fontFamily: fontMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text(theme10_lbl_dont_have_account,
                      textColor: t10_textColorSecondary,
                      fontFamily: fontMedium),
                  SizedBox(
                    width: spacing_control,
                  ),
                  GestureDetector(
                    child: text(theme10_lbl_sign_up, fontFamily: fontMedium),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                  )
                ],
              ),
              _requesting
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : SizedBox()
            ],
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
