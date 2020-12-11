import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_app/models/token.dart';
import 'package:token_app/models/user.dart';

import '../api/api.dart';

class PreferencesProvider with ChangeNotifier {
  //important variables
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _isCorrect = true;
  User user;
  List<Token> _tokens;

  //my getters
  get getUser => user;
  get isLoggedIn => _isLoggedIn;
  get isLoading => _isLoading;
  get isCorrect => _isCorrect;
  get getTokens => _tokens;

  //do the checks in the constructor
  PreferencesProvider() {
    _fetchUser().then((data) {
      if (data.name != null) {
        user = data;
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    });
  }

  //get session data....
  Future<User> _fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = new User();
    user.id = prefs.getInt('id');
    user.name = prefs.getString('name');
    user.email = prefs.getString('email');
    user.number = prefs.getString('number');
    notifyListeners();
    return user;
  }

  //save the user preferences
  saveUserPrefs(User userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = userModel.toMap();
    await prefs.setInt('id', map["id"]);
    await prefs.setString('name', map["name"]);
    await prefs.setString('email', map["email"]);
    await prefs.setString('number', map["number"]);
    notifyListeners();
  }

  setUserModel(User user) {
    user = user;
    notifyListeners();
  }

  _fetchTokens(int id) {
    API.getTokens(id).then((response) {
      Iterable list = json.decode(response.body);
      _tokens = list.map((model) => Token.fromJson(model)).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
