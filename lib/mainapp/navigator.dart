import 'package:flutter/material.dart';
import 'newusers/index.dart';
import 'normal/index.dart';
import './newusers/License.dart';
// add a register routes function

Future<Map<String, WidgetBuilder>> routes() async {
  var l = await License();
  return {
    '/WelcomeScreen': (context) => WelcomeScreen(),
    '/Agreement': (context) => AgreementScreen(),
    '/License': (context) => License(),
    '/AllowPerms': (context) => PermissionScreen(),
    '/HomePage': (context) => HomePage(),
    '/senddata': (context) => SendData(),
    '/joystick': (context) => Joystick(),
  };
}

