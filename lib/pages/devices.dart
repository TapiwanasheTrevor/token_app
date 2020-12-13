import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:token_app/api/api.dart';
import 'package:token_app/models/device.dart';
import 'package:token_app/utils/AppConstant.dart';

class Devices extends StatefulWidget {
  @override
  DeviceState createState() => DeviceState();
}

class DeviceState extends State<Devices> {
  List<Device> _devices = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  _fetchDevices() {
    API.getDevices().then((response) {

      Iterable list = jsonDecode(response.body);
      setState(() {
        _devices = list.map((model) => Device.fromJson(model)).toList();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Consumptions"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (BuildContext context, int index) {
                  Device device = _devices[index];
                  return GestureDetector(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "${device.name}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${device.description}",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic),
                          ),
                          
                          trailing: Text("${device.wattage.toString()} watts"),
                        ),
                        Divider(
                          height: 2.0,
                        ),
                      ],
                    ),
                    onTap: () {

                    },
                  );
                }),
      ),
    );
  }
}
