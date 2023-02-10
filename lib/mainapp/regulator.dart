import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ble_scala/mainapp/normal/index.dart';
import 'package:path_provider/path_provider.dart';
import '.././basemodules/bluetooth/useBLE.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'newusers/index.dart';
import './navigator.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../basemodules/sqlite/useSQL.dart';

final sqlHandler = SQLHandler();

var bleHandler = BluetoothHandler();

class regulator extends StatelessWidget {
  final json;
  final r;
  regulator(this.json, this.r);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    if (json["newuser"] == true) {
      return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          routes: r,
          home: WelcomeScreen(),
        ),
      );
    } else {
      return LocalizationProvider(
          state: LocalizationProvider.of(context).state,
          child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              localizationDelegate
            ],
            supportedLocales: localizationDelegate.supportedLocales,
            locale: localizationDelegate.currentLocale,
            routes: r,
            home: HomePage(),
          ));
    }
  }
}

regulatorAsync() async {
  try {
    await sqlHandler.openDB(
        "main.db", 1, "CREATE TABLE main (key TEXT, value)");
  } catch (e) {
    // create the table main
    await sqlHandler.execute(await sqlHandler.openDB('main.db', 1, ''),
        "CREATE TABLE main (key TEXT, value)");
  }
  // check if the key newuser exists
  var db = await sqlHandler.openDB(
      "main.db", 1, "CREATE TABLE main (key TEXT, value)");
  var a = await sqlHandler.query(db, "main", "key = 'newuser'");
  if (a.length == 0) {
    // if it doesn't exist, create it
    await sqlHandler.insert(db, "main", {"key": "newuser", "value": "true"});
  }
  // get the value of the key newuser
  var b = await sqlHandler.query(db, "main", "key = 'newuser'");
  var js = {"newuser": b[0]["value"] == "true"};
  var c = regulator(js, await routes());
  return c;
}
