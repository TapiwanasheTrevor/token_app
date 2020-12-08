import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
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
  TextEditingController meter = new TextEditingController();
  TextEditingController number = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController cpassword = new TextEditingController();

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
                  text: "Meter Number",
                  isPassword: false,
                  mController: meter,
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
                AppButton(
                  onPressed: () {
                    if (name.text != "" &&
                        email.text != "" &&
                        meter.text != "" &&
                        number.text != "" &&
                        password.text != "" &&
                        cpassword.text != "") {
                      setState(() {
                        progressDialog.show();
                      });

                      API
                          .register(name.text, email.text, meter.text,
                              number.text, password.text, cpassword.text)
                          .then((response) {
                        print(response);

                        User user = User.fromJson(json.decode(response.body));

                        if (user.id != null) {
                          //saveUserPrefs(userModel);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {}
                      });
                    } else {
                      print("error");
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
}
