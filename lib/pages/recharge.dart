import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:token_app/api/api.dart';
import 'package:token_app/models/meter.dart';
import 'package:token_app/models/token.dart';
import 'package:token_app/pages/pricesheet.dart';
import 'package:token_app/utils/Constant.dart';
import 'package:token_app/utils/Widget.dart';

class RechargeScreen extends StatefulWidget {
  Meter meter;

  RechargeScreen({this.meter});

  @override
  RechargeScreenState createState() => RechargeScreenState();
}

class RechargeScreenState extends State<RechargeScreen> {
  bool _isLoading = true;
  String _message = "";
  List<Token> _tokens = [];
  int _units = 0;
  TextEditingController amount = new TextEditingController();

  @override
  void initState() {
    _fetchTokens(widget.meter.id);
  }

  _fetchTokens(int id) {
    API.getTokens(id).then((response) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      Iterable list = data['tokens'];
      setState(() {
        _tokens = list.map((model) => Token.fromJson(model)).toList();
        _units = data['units'];
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meter Number: ${widget.meter.number}",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blue,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
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
                        "${_units.toString()} units",
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
                    "${widget.meter.address}",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.blue[100]),
                  ),
                  SizedBox(
                    height: 24,
                  ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Recent Token Purchases",
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
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: _units > 0
                                          ? _units > 300
                                              ? Colors.green
                                              : Colors.orange
                                          : Colors.red,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Meter Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.grey[900]),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
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
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: _tokens.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      children: <Widget>[
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
                                              "+${_tokens[index].units} units",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.lightGreen),
                                            ),
                                            Text(
                                              "",
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
                mController: amount,
              ),
              Text(
                _message,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              )
            ]),
            buttons: [
              DialogButton(
                child: Text(
                  "Buy Token",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  if (amount.text != "") {
                    API.buyToken(amount.text, widget.meter.id).then((value) {
                      _fetchTokens(widget.meter.id);
                      Navigator.pop(context);
                    });
                  } else {
                    setState(() {
                      _message = "Supply Value for Amount";
                    });
                  }
                },
              )
            ],
            title: "Buy Credit",
          ).show();
        },
        elevation: 0,
        child: Icon(Icons.add),
      ),
    );
  }
}
