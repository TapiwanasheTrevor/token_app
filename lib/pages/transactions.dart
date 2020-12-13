import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_app/models/meter.dart';
import 'package:token_app/pages/recharge.dart';

import '../api/api.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Meter> _meters;
  User user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser().then((data) {
      print(data.email);
      if (data.name != null) {
        _fetchMeters(data.id);
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
    return user;
  }

  _fetchMeters(int id) {
    API.getMeters(id).then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        _meters = list.map((model) => Meter.fromJson(model)).toList();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _meters.length,
              itemBuilder: (BuildContext context, int index) {
                Meter meter = _meters[index];
                return GestureDetector(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "${meter.number}",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${meter.address}",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                        ),
                        leading: Icon(Icons.power),
                        trailing: CircleAvatar(
                          radius: 8,
                          backgroundColor: _meters[index].units > 0
                              ? _meters[index].units > 300
                                  ? Colors.green
                                  : Colors.orange
                              : Colors.red,
                        ),
                      ),
                      Divider(
                        height: 2.0,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RechargeScreen(
                                meter: meter,
                              )),
                    );
                  },
                );
              }),
    );
  }

  static refreshData() {}
}
