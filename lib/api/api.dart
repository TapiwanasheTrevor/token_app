import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:token_app/utils/AppConstant.dart';

const url = BaseUrl;

class API {
  static Future register(String name, String email, String number,
      String password, String cpassword) {
    return http.post(
      url + 'register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
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

  static Future getMeters(int id) {
    return http.get(
      url + 'meters/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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

  static Future addMeter(String number, String address, int id) {
    print(url + 'meters/add');
    return http.post(
      url + 'meters/add',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'number': number,
        'address': address,
        'id': id.toString()
      }),
    );
  }

  static Future buyToken(String amount, int id) {
    return http.post(
      url + 'buy',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'amount': amount, 'id': id.toString()}),
    );
  }

  static Future getDevices() {
    return http.get(
      url + 'devices',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
