import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:token_app/utils/AppConstant.dart';

const url = BaseUrl;

class API {
  static Future register(String name, String email, String meter, String number,
      String password, String cpassword) {
    return http.post(
      url + 'register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'meter': meter,
        'password': password,
        'number': number,
        'password_confirmation': cpassword
      }),
    );
  }

  static Future login(String email, String password) {
    return http.post(
      url + 'login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }

  static Future getTokens(int id) {
    return http.get(
      url + 'tokens/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
