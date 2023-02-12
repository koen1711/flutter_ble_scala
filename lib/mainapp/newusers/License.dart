import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:rive_loading/rive_loading.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ALicense extends StatefulWidget {
  @override
  _ALicenseState createState() => _ALicenseState();
}

class _ALicenseState extends State<ALicense> {
  // initiate the ALicense with a string parameter called license
  String license = "";
  bool _isLoading = true;
  _ALicenseState();

  Future<String> _licenseGenerate(context) async {
    // get flutter_translate delegate out of context
    var delegate = LocalizedApp.of(context).delegate;
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
    setState(() {
      license = licenseText;
      _isLoading = false;
    });
    return licenseText;
  }

  Widget _language(context) {
    if (!license.startsWith("Versie")) {
      return Text("Official License");
    }
    return Container(
      // width 100% of the screen
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[400],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Nederlandse versie onofficieel, voor de officiële versie klik op de knop hieronder.",
            textAlign: TextAlign.left,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 10,
              color: Color(0xff000000),
            ),
          ),
          MaterialButton(
            color: Colors.blue[300],
            child: Text("Official License"),
            onPressed: () async {
              var url =
                  "https://raw.githubusercontent.com/koen1711/flutter_ble_scala/main/LICENSE";
              var response = await get(Uri.parse(url));
              license = response.body;
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _licenseGenerate(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
          elevation: 4,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff3a57e8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            translate("newusers.licensescreen.text2"),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14,
              color: Color(0xff000000),
            ),
          ),
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,
              semanticLabel: 'Back',
            ),
          )),
      body: license == ""
          ? Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RiveLoading(
                              // width and height are the full  width and height of the screen
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              name: 'lib/mainapp/newusers/loading.riv',
                              loopAnimation: 'Timeline 1',
                              isLoading: _isLoading,
                              onSuccess: (_) {
                                print('Finished');
                              },
                              onError: (err, stack) {
                                print(err);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                _language(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      license,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 10,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
