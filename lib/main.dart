import 'package:flutter/material.dart';
import 'mainapp/regulator.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.dutch);
  // ignore some logs
  Logger.root.level = Level.WARNING;
  // Check for permissions
  var licenseTexta = await http.get(Uri.parse(
      "https://raw.githubusercontent.com/koen1711/flutter_ble_scala/main/LICENSE"));
  var licenseText = licenseTexta.body.toString();
  // write a file to the document directory.
  // check if the data.json file exists

  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'nl', supportedLocales: ['en', 'nl']);
  if (delegate.currentLocale == Locale.fromSubtags(languageCode: 'en')) {
    // translate each line seperately of licesenseText
    var lines = licenseText.split("\n");
    var translatedLines = [];
    for (var line in lines) {
      var translatedLine = await onDeviceTranslator.translateText(line);
      translatedLines.add(translatedLine);
    }
    licenseText = translatedLines.join("\n");
  }
  runApp(LocalizedApp(delegate, await regulatorAsync(licenseText)));
  // put the license in a file
  var path = await getApplicationDocumentsDirectory();
  var pathstr = path.toString();
  print(pathstr);
}
