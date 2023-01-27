import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ALicense extends StatefulWidget {
  String license;
  ALicense(this.license);


  @override
  _ALicenseState createState() => _ALicenseState(license);
}

class _ALicenseState extends State<ALicense> {
  // initiate the ALicense with a string parameter called license
  String license;
  _ALicenseState(this.license);

  Widget _language(context) {
    if (!license.startsWith("Aangepaste")) {
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
              var url = "https://raw.githubusercontent.com/koen1711/flutter_ble_scala/main/LICENSE";
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
            "LICENSE",
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
      body: Column(
        children: [
          _language(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
