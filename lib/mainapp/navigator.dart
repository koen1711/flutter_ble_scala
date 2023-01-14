import 'package:flutter/material.dart';
import 'newusers/index.dart';
import 'newusers/License.dart';
import './normal/index.dart';
// add a register routes function

Map<String, WidgetBuilder> routes(String licenseText) {
  return {
    '/WelcomeScreen': (context) => WelcomeScreen(),
    '/Agreement': (context) => AgreementScreen(),
    '/License': (context) => ALicense(license: licenseText),
    '/AllowPerms': (context) => PermissionScreen(),
    '/HomePage': (context) => HomePage()
  };
}

