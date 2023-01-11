import 'package:flutter/material.dart';
import 'mainapp/regulator.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check for permissions
  var sjson = await rootBundle.loadString('lib/mainapp/data.json');
  var js = jsonDecode(sjson);
  runApp(regulator(js));
  
  
}
