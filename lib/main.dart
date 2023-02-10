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

  
  runApp(LocalizedApp(delegate, await regulatorAsync()));
  
}
