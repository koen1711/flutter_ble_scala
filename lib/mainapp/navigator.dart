import 'package:flutter/material.dart';
import 'newusers/index.dart';
import 'normal/index.dart';
// add a register routes function

Map<String, WidgetBuilder> routes(String licenseText) {
  return {
    '/WelcomeScreen': (context) => WelcomeScreen(),
    '/Agreement': (context) => AgreementScreen(),
    '/License': (context) => License(licenseText),
    '/AllowPerms': (context) => PermissionScreen(),
    '/HomePage': (context) => HomePage(),
    '/senddata': (context) => SendData(),
    '/joystick': (context) => Joystick(),
  };
}

