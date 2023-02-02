import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AHomeScreen extends StatelessWidget {
  AHomeScreen();
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('What do you want to do today?', style: TextStyle(color: Colors.black))),
        // make the appbar transparent
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xfff2f3f4),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GridView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.pushNamed(context, '/joystick')
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.all(0),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff5f75e6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              "Control your leaphy",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 13,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      )

                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,

                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.pushNamed(context, '/senddata')
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xffe260b7),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Text(
                                "Send data",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 13,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              height: 170,
              decoration: BoxDecoration(
                color: Color(0x00ffffff),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
