

import 'package:flutter/material.dart';
import 'newusers/index.dart';
import 'newusers/License.dart';
// add a register routes function

Map<String, WidgetBuilder> newUserRoutes(String licenseText) {
  return {
    '/WelcomeScreen': (context) => WelcomeScreen(),
    '/Agreement': (context) => AgreementScreen(),
    '/License': (context) => ALicense(license: licenseText),
    //'/AllowPerms': (context) => PermissionScree(),
  };
}