import 'package:flutter/material.dart';
import 'mainapp/regulator.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check for permissions
  var sjson = await rootBundle.loadString('lib/mainapp/data.json');
  var licenseTexta = await http.get(Uri.parse(
      "https://raw.githubusercontent.com/koen1711/flutter_ble_scala/main/LICENSE"));
  var licenseText = licenseTexta.body.toString();
  var js = jsonDecode(sjson);
  runApp(regulator(js, licenseText));
}
