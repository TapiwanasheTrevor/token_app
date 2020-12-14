import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_app/api/api.dart';
import 'package:token_app/auth/SignIn.dart';
import 'package:token_app/models/meter.dart';
import 'package:token_app/models/user.dart';
import 'package:token_app/pages/recharge.dart';
import 'package:token_app/pages/transactions.dart';
import 'package:token_app/utils/Constant.dart';
import 'package:token_app/utils/Widget.dart';

import 'devices.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController number = new TextEditingController();
  TextEditingController address = new TextEditingController();
  User user;
  bool _isfetching = true;
  List<Meter> _meters;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser().then((data) {
      setState(() {
        user = data;
        _fetchMeters(user.id);
        _isfetching = false;
      });
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
    return _isfetching
        ? Scaffold(
            body: Center(
              child: Text("Initialising ..."),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("My Meters"),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    onPressed: null)
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.green,
                      backgroundImage: AssetImage('assets/logo.png'),
                    ),
                    accountName: _isfetching ? Text("") : Text(user.name),
                    accountEmail: _isfetching ? Text("") : Text(user.email),
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_turned_in),
                    title: Text("Devices"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Devices()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.power_settings_new),
                    title: Text("Log Out"),
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                number.text = "";
                address.text = "";
                Alert(
                  context: context,
                  type: AlertType.none,
                  content: Column(children: [
                    SizedBox(
                      height: spacing_large,
                    ),
                    EditText(
                      text: "Meter Number",
                      isPassword: false,
                      mController: number,
                    ),
                    SizedBox(
                      height: spacing_large,
                    ),
                    EditText(
                      text: "Meter Address",
                      isPassword: false,
                      mController: address,
                    ),
                  ]),
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Add Meter",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        API
                            .addMeter(number.text, address.text, user.id)
                            .then((value) => {Navigator.pop(context)});
                        _fetchMeters(user.id);
                      },
                    )
                  ],
                  title: "Add Meter",
                ).show();
              },
              elevation: 0,
              child: Icon(Icons.add),
            ),
            body: _isLoading
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
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
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
}
