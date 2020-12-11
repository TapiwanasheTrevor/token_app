import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_app/models/token.dart';
import 'package:token_app/pages/pricesheet.dart';

import '../api/api.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Token> _tokens;
  User user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchUser().then((data) {
      print(data.name);

      if (data.name != null) {
        _fetchTokens(user.id);
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

  _fetchTokens(int id) {
    API.getTokens(id).then((response) {
      Iterable list = json.decode(response.body);
      _tokens = list.map((model) => Token.fromJson(model)).toList();
      _isLoading = false;
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
          : Stack(
              children: <Widget>[
                //Container for top data
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "2589 units",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.notifications,
                                  color: Colors.lightBlue[100],
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/logo.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Available Balance",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.blue[100]),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(243, 245, 248, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.blue[900],
                                    size: 30,
                                  ),
                                  padding: EdgeInsets.all(12),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Purchases",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.blue[100]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(243, 245, 248, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: Icon(
                                    Icons.public,
                                    color: Colors.blue[900],
                                    size: 30,
                                  ),
                                  padding: EdgeInsets.all(12),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Request",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.blue[100]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.attach_money,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Prices",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PriceSheet()));
                              },
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(243, 245, 248, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: Icon(
                                    Icons.trending_down,
                                    color: Colors.blue[900],
                                    size: 30,
                                  ),
                                  padding: EdgeInsets.all(12),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Topup",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.blue[100]),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                //draggable sheet
                DraggableScrollableSheet(
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 245, 248, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Recent Transactions",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "See all",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.grey[800]),
                                  )
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                            ),
                            SizedBox(
                              height: 24,
                            ),

                            //Container for buttons
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.grey[900]),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[200],
                                              blurRadius: 10.0,
                                              spreadRadius: 4.5)
                                        ]),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Recent",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Colors.grey[900]),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[200],
                                              blurRadius: 10.0,
                                              spreadRadius: 4.5)
                                        ]),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.orange,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "History",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Colors.grey[900]),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[200],
                                              blurRadius: 10.0,
                                              spreadRadius: 4.5)
                                        ]),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  )
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 16,
                            ),
                            //Container Listview for expenses and incomes
                            Container(
                              child: Text(
                                "TODAY",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[500]),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                            ),

                            SizedBox(
                              height: 16,
                            ),
                            ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 32),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Icon(
                                          Icons.date_range,
                                          color: Colors.lightBlue[900],
                                        ),
                                        padding: EdgeInsets.all(12),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Payment",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[900]),
                                            ),
                                            Text(
                                              "Purchased new token",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "+500 units",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.lightGreen),
                                          ),
                                          Text(
                                            "01 Dec",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              itemCount: 1,
                              padding: EdgeInsets.all(0),
                              controller:
                                  ScrollController(keepScrollOffset: false),
                            ),

                            //now expense
                            SizedBox(
                              height: 16,
                            ),

                            Container(
                              child: Text(
                                "LAST WEEK",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[500]),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 32),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Icon(
                                          Icons.directions_car,
                                          color: Colors.lightBlue[900],
                                        ),
                                        padding: EdgeInsets.all(12),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Payment",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[900]),
                                            ),
                                            Text(
                                              "Purchased new token",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "+324 units",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.orange),
                                          ),
                                          Text(
                                            "01 Nov",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              itemCount: 1,
                              padding: EdgeInsets.all(0),
                              controller:
                                  ScrollController(keepScrollOffset: false),
                            ),

                            //now expense
                          ],
                        ),
                        controller: scrollController,
                      ),
                    );
                  },
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 1,
                )
              ],
            ),
    );
  }
}
