import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'mainapp/regulator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'background/background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.dutch);
  // ignore some logs
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
}
