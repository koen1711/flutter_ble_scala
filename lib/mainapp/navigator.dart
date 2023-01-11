

import 'package:flutter/material.dart';
import 'newusers/index.dart';

// add a register routes function

Map<String, WidgetBuilder> newUserRoutes() {
  return {
    '/WelcomeScreen': (context) => WelcomeScreen(),
    '/Agreement': (context) => AgreementScreen(),
    //'/AllowPerms': (context) => PermissionScree(),
  };
}