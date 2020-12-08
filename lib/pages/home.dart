import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:token_app/pages/transactions.dart';
import 'package:token_app/utils/Constant.dart';
import 'package:token_app/utils/Widget.dart';

import 'appliances.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var screens = [
    HomeScreen(),
    CardScreen(),
  ]; //screens for each tab

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 81, 158, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Devices")),
        ],
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        showUnselectedLabels: true,
        iconSize: 30,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Alert(
            context: context,
            type: AlertType.none,
            content: Column(children: [
              SizedBox(
                height: spacing_large,
              ),
              EditText(
                text: "Amount to Pay",
                isPassword: false,
              ),
            ]),
            buttons: [
              DialogButton(
                child: Text(
                  "Purchase Token",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {},
              )
            ],
            title: "RECHARGE ACCOUNT",
          ).show();
        },
        elevation: 0,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[selectedTab],
    );
  }
}
