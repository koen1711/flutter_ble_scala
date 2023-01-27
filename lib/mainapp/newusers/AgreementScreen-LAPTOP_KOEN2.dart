import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_ble_scala/mainapp/regulator.dart';
import 'package:path_provider/path_provider.dart';
import '../../basemodules/sqlite/useSQL.dart';

var sqlHandler = SQLHandler();

class _AgreementScreen extends State<AAgreementScreen> {
  bool _termsAccepted = false;

  @override
  void initState() {
    _termsAccepted = false;
  }

  void acceptAgreement() {
    setState(() {
      _termsAccepted = true;
    });
  }

  void declineAgreement() {
    setState(() {
      _termsAccepted = false;
    });
  }
  // ···

  Widget _buildContinueButton() {
    if (_termsAccepted) {
      return MaterialButton(
        onPressed: () async {
          // write data to file
          var db = await sqlHandler.openDB(
              "main.db", 1, "CREATE TABLE main (key TEXT, value)");

          // override the value of newuser
          await sqlHandler.execute(
              db, "UPDATE `main` SET `value`='false' WHERE key='newuser';");

          print(await sqlHandler.query(db, "main", "key = 'newuser'"));

          Navigator.of(context).pushReplacementNamed('/AllowPerms');
        },
        color: Color(0xffffffff),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        padding: EdgeInsets.all(16),
        child: Text(
          "Continue to Allowing Permissions",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        textColor: Color(0xff3a57e8),
        height: 45,
        minWidth: 150,
      );
    } else {
      return MaterialButton(
        onPressed: () {},
        color: Color(0xffffffff),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        padding: EdgeInsets.all(16),
        child: Text(
          "Continue to Allowing Permissions",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        textColor: Color.fromARGB(255, 129, 131, 143),
        height: 45,
        minWidth: 150,
      );
    }
  }

  Widget _buildCheckBox() {
    if (_termsAccepted) {
      return Checkbox(
        onChanged: (value) {
          if (value == true) {
            acceptAgreement();
          } else {
            declineAgreement();
          }
        },
        activeColor: Color(0xff3a57e8),
        autofocus: false,
        checkColor: Color(0xffffffff),
        hoverColor: Color(0x42000000),
        splashRadius: 20,
        value: true,
      );
    }
    return Checkbox(
      onChanged: (value) {
        if (value == true) {
          acceptAgreement();
        } else {
          declineAgreement();
        }
      },
      activeColor: Color(0xff3a57e8),
      autofocus: false,
      checkColor: Color(0xffffffff),
      hoverColor: Color(0x42000000),
      splashRadius: 20,
      value: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3a57e8),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Align(
              alignment: Alignment(0.0, 0.0),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Agreement",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/License');
                          },
                          color: Color(0xffffffff),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(
                                color: Color.fromARGB(0, 255, 255, 255),
                                width: 0),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Click here for the LICENSE",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          textColor: Color(0xff0f00ff),
                          height: 40,
                          minWidth: 140,
                        ),
                      ),
                      Text(
                        "By checking the Check Box below you agree to the LICENSE listed above",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          fontSize: 9,
                          color: Color(0xff000000),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.1, 0.0),
                        child: _buildCheckBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment(0.0, 0.9), child: _buildContinueButton()),
          ],
        ),
      ),
    );
  }
}

class AAgreementScreen extends StatefulWidget {
  const AAgreementScreen();

  // create state for the user to accept the agreement
  @override
  State<AAgreementScreen> createState() => _AgreementScreen();
}
