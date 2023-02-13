import 'dart:async';

import 'package:flutter_ble_scala/mainapp/normal/HomePage.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/material.dart';
import 'FindDevices.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import '../modals/CalibrateMotors.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_cube/flutter_cube.dart';

const ballSize = 20.0;
const step = 10.0;

class AJoystick extends StatefulWidget {
  const AJoystick({Key? key}) : super(key: key);

  @override
  _Joystick createState() => _Joystick();
}

class _Joystick extends State<AJoystick> with WidgetsBindingObserver {
  bool a = false;
  double _x = 100;
  double _y = 100;
  Timer? _timer;
  String _previousCommand = "";
  CustomBluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
          if (_previousCommand != "") {
            _selectedDevice!.send(_previousCommand);
          }
        });
        break;
      case AppLifecycleState.paused:
        _timer?.cancel();
        break;
      default:
        break;
    }
  }

  void _openSecondScreen() {
    _timer?.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FindDevices(
          onDataSubmitted: (CustomBluetoothDevice data) {
            setState(() {
              _selectedDevice = data;
              _timer =
                  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
                if (_previousCommand != "") {
                  _selectedDevice!.send(_previousCommand);
                }
              });
            });
          },
        ),
      ),
    );
  }

  Widget _joyStick() {
    // if (_selectedDevice != null) then show joystick else show button
    if (_selectedDevice != null) {
      return Joystick(
        mode: JoystickMode.horizontalAndVertical,
        listener: (details) {
          _x = details.x * 100;
          _y = details.y * 100;
          _x = _x * -1;
          _y = _y * -1;
          setState(() {
            _previousCommand = "D,0,0";
          });

          if (_x == -0) {
            // check if y is positive or negative
            if (_y > 0) {
              if (_previousCommand != "D,1,${_y.toInt()}") {
                setState(() {
                  _previousCommand = "D,1,${_y.toInt()}";
                });
              }
            } else {
              if (_previousCommand != "D,2,${_y.toInt()}") {
                setState(() {
                  _previousCommand = "D,2,${_y.toInt()}";
                });
              }
            }
          } else {
            // check if x is positive or negative
            if (_x > 0) {
              if (_previousCommand != "D,3,${_x.toInt()}") {
                setState(() {
                  _previousCommand = "D,3,${_x.toInt()}";
                });
              }
            } else {
              if (_previousCommand != "D,4,${_x.toInt()}") {
                setState(() {
                  _previousCommand = "D,4,${_x.toInt()}";
                });
              }
            }
          }
        },
      );
    } else {
      return ElevatedButton(
          onPressed: () {
            _openSecondScreen();
          },
          child: Text("Select Device"));
    }
  }

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_previousCommand != "") {
        _selectedDevice!.send(_previousCommand);
      }
    });
    a = true;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
          title: const Text('Drive your leaphy'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AHomeScreen()));
            },
          )),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.green,
            ),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Column(children: [
                Stack(children: <Widget>[
                  Container(
                    width: 360,
                    height: 400,
                    child: Cube(
                      interactive: false,
                      onSceneCreated: (Scene scene) {
                        // add texture to the scene
                        //add button to the scene

                        scene.world.add(Object(
                          fileName: 'assets/models/Arduino.obj',
                          position: Vector3(0, 0, 0),
                          scale: Vector3(7.5, 7.5, 7.5),
                          rotation: Vector3(180, 270, 90),
                          // add a texture to the object
                      	));
                      },
                    ),
                  ),
                  Positioned(
                    width: 10,
                    height: 85,
                    bottom: 55,
                    left: 280,
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: Text(""),
                    ),
                  ),
                  Positioned(
                    width: 10,
                    height: 85,
                    bottom: 150,
                    left: 280,
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: Text(""),
                    ),
                  ),
                  Positioned(
                    width: 10,
                    height: 70,
                    bottom: 55,
                    left: 73,
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: Text(""),
                    ),
                  ),
                  Positioned(
                    width: 10,
                    height: 70,
                    bottom: 130,
                    left: 73,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Button 2");
                      },
                      child: Text(""),
                    ),
                  )
                ]),
                _selectedDevice == null
                    ? Container()
                    : ElevatedButton(
                        onPressed: () async {
                          // go to calibrate motors modal
                          showBarModalBottomSheet(
                              context: context,
                              builder: (context) => CalibrateMotors(
                                    onDataSubmitted: (r) async {
                                      // send command to calibrate motors
                                      _selectedDevice!.send(r);
                                    },
                                    device: _selectedDevice,
                                  ));
                        },
                        child: Container(
                            width: 200, child: const Text("Calibrate Motors"))),
                _joyStick()
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
