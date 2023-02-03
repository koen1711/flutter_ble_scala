import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'mainapp/regulator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'background/background.dart';
// import logger
import 'package:logger/logger.dart' show Logger, Level;
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'nl', supportedLocales: ['en', 'nl']);
  // turn of logging of google_mlkit_translation
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.dutch);

  var licenseTexta = await http.get(Uri.parse(
      "https://raw.githubusercontent.com/koen1711/flutter_ble_scala/main/LICENSE"));
  var licenseText = licenseTexta.body.toString();
  var version = licenseText.split("\n")[0];
  var versionNumber = version.split(" ")[1];

  var dir = await getApplicationDocumentsDirectory();
  var path = dir.path;
  var nlFile = File('$path/LICENSE$versionNumber-nl.txt');
  var enFile = File('$path/LICENSE$versionNumber-en.txt');
  if (await nlFile.exists() && await enFile.exists()) {
    if (delegate.currentLocale == Locale.fromSubtags(languageCode: 'nl')) {
      licenseText = await nlFile.readAsString();
    }
  } else {
    var lines = licenseText.split("\n");
    var translatedLines = [];
    for (var line in lines) {
      var translatedLine = await onDeviceTranslator.translateText(line);
      translatedLines.add(translatedLine);
    }
    var dutchText = translatedLines.join("\n");
    // write the file
    await nlFile.writeAsString(dutchText);
    await enFile.writeAsString(licenseText);
    if (delegate.currentLocale == Locale.fromSubtags(languageCode: 'nl')) {
      licenseText = dutchText;
    }
  }
  runApp(LocalizedApp(delegate, await regulatorAsync(licenseText)));
}
