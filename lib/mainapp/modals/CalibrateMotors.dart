import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../basemodules/sqlite/useSQL.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import 'dart:async';

final sqlHandler = SQLHandler();

// make a modal to calibrate the motors
class CalibrateMotors extends StatefulWidget {
  final Function(String) onDataSubmitted;
  final CustomBluetoothDevice? device;

  CalibrateMotors({required this.onDataSubmitted, required this.device});

  @override
  ACalibrateMotors createState() =>
      ACalibrateMotors(onDataSubmitted: onDataSubmitted, device: device);
}

class ACalibrateMotors extends State<CalibrateMotors>
    with WidgetsBindingObserver {
  ACalibrateMotors({required this.onDataSubmitted, required this.device});
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
        timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
          _heartbeat();
        });
        break;
      case AppLifecycleState.paused:
        timer?.cancel();
        break;
      default:
        break;
    }
  }

  void _heartbeat() {
    
    if (driving) {
      print("heartbeat: $driving");
      device!.send("CALIBRATE,$leftMotor,$rightMotor");
    } else {
      device!.send("DRIVE,0,0");
    }
  }

  Widget build(BuildContext context) {
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _heartbeat();
    });
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          onDataSubmitted("CALIBRATE,$leftMotor,$rightMotor");
          return true;
        },
        child: Navigator(
          pages: [
            MaterialPage(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Calibrate Motors"),
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
                                  print("driving: $driving");
                                  if (driving) {
                                    device!.send(
                                        "CALIBRATE,$leftMotor,$rightMotor");
                                  } else {
                                    device!.send("DRIVE,0,0");
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
