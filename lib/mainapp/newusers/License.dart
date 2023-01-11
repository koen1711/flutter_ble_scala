import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ALicense extends StatelessWidget  {
  // initiate the ALicense with a string parameter called license
  var license;
  ALicense({this.license});

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
        leading: MaterialButton(onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back, color: Colors.white, size: 24.0, semanticLabel: 'Back',),

        )
      ),
      body: Column(
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
    );
  }
}