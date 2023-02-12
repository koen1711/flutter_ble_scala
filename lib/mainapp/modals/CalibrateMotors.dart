import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../basemodules/sqlite/useSQL.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import 'dart:async';

final sqlHandler = SQLHandler();

// make a modal to C the motors
class CalibrateMotors extends StatefulWidget {
  final Function(String) onDataSubmitted;
  final CustomBluetoothDevice? device;

  CalibrateMotors({required this.onDataSubmitted, required this.device});

  @override
  ACMotors createState() =>
      ACMotors(onDataSubmitted: onDataSubmitted, device: device);
}

class ACMotors extends State<CalibrateMotors> with WidgetsBindingObserver {
  ACMotors({required this.onDataSubmitted, required this.device});
  bool isDragging = false;
  bool driving = false;
  int leftMotor = 50;
  Timer? timer;
  TextEditingController leftMotorController = TextEditingController();
  int rightMotor = 50;
  TextEditingController rightMotorController = TextEditingController();
  final Function(String) onDataSubmitted;
  final CustomBluetoothDevice? device;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      default:
        break;
    }
  }

  

  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          onDataSubmitted("C,$leftMotor,$rightMotor");
          return true;
        },
        child: Navigator(
          pages: [
            MaterialPage(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("C Motors"),
                ),
                body: Center(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text("Left Motor"),
                          Text(leftMotor.toString()),
                          Slider(
                            value: leftMotor.toDouble(),
                            min: 0,
                            max: 100,
                            onChangeEnd: (value) {
                              if (driving) {
                                device!.send("C,$leftMotor,$rightMotor");
                              }
                              setState(() {
                                leftMotor = value.toInt();
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                leftMotor = value.toInt();
                              });
                            },
                          ),
                          Text("Right Motor"),
                          Text(rightMotor.toString()),
                          Slider(
                            value: rightMotor.toDouble(),
                            min: 0,
                            max: 100,
                            onChangeEnd: (value) {
                              if (driving) {
                                device!.send("C,$leftMotor,$rightMotor");
                              }
                              setState(() {
                                rightMotor = value.toInt();
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                rightMotor = value.toInt();
                              });
                            },
                          ),
                          // button for stopping the motors and starting the motors
                          ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                 
                                  driving = !driving;
                                  if (driving) {
                                    device!.send(
                                        "D,1,100");
                                    device!.send(
                                        "C,$leftMotor,$rightMotor");
                                  } else {
                                    device!.send("D,0,0");
                                  }
                                });
                              },
                              child: Text(driving ? "Stop" : "Start"))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            return true;
          },
        ),
      ),
    );
  }
}
