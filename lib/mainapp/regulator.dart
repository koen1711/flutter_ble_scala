import 'package:flutter/material.dart';
import '.././basemodules/bluetooth/useBLE.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'newusers/index.dart';
import './navigator.dart';
var bleHandler = BluetoothHandler();

MaterialApp regulator(var json, String licenseText) {
  // check if new user from data.json ()
  

  if (json["newuser"] == true) {
    print("New user");
    return MaterialApp(
        home: WelcomeScreen(),
        routes: routes(licenseText),
      );
  } else {
    print("a");
    return MaterialApp(
        routes: routes(licenseText),
        home: Scaffold(
      body: Center(
        child: Text("a"),
        
      ),
    ));
  }
}
