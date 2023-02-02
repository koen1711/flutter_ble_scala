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

  // ignore some logs
  // Check for permissions
  var licenseTexta = await http.get(Uri.parse(
      "https://raw.githubusercontent.com/koen1711/flutter_ble_scala/main/LICENSE"));
  var licenseText = licenseTexta.body.toString();
  // get only the first sentence of the license
  var version = licenseText.split("\n")[0];
  var versionNumber = version.split(" ")[1];
  // if we already translated this version, don't translate it again (check if the path LICENSE{versionNumber}-nl and LICENSE{versionNumber}-en exists)
  // if it doesn't exist, translate it and save it to the document directory
  var dir = await getApplicationDocumentsDirectory();
  var path = dir.path;
  // open the file and read the license text
  var nlFile = File('$path/LICENSE$versionNumber-nl.txt');
  var enFile = File('$path/LICENSE$versionNumber-en.txt');
  if (await nlFile.exists() && await enFile.exists()) {
    // read the file
    if (delegate.currentLocale == Locale.fromSubtags(languageCode: 'en')) {
      licenseText = await nlFile.readAsString();
    }
  } else {
    // translate each line seperately of licesenseText
    var lines = licenseText.split("\n");
    var translatedLines = [];
    for (var line in lines) {
      var translatedLine = await onDeviceTranslator.translateText(line);
      translatedLines.add(translatedLine);
    }
    var licenseText2 = translatedLines.join("\n");
    // write the file
    await nlFile.writeAsString(licenseText2);
    await enFile.writeAsString(licenseText);
  }
  runApp(LocalizedApp(delegate, await regulatorAsync(licenseText)));
}
