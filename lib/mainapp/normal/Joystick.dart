import 'dart:async';

import 'package:flutter_ble_scala/mainapp/normal/HomePage.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/material.dart';
import 'FindDevices.dart';
import '../../basemodules/bluetooth/useBLE.dart';

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
  String _previousCommand = "";
  Timer? timer;
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
        
        break;
      case AppLifecycleState.paused:
        timer?.cancel();
        break;
      default:
        break;
    }
  }

  void _bluetoothHeartbeat() {
    // run the last command
    _selectedDevice!.send(_previousCommand);
  }

  void _openSecondScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FindDevices(
          onDataSubmitted: (CustomBluetoothDevice data) {
            setState(() {
              _selectedDevice = data;
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
          if (_x == -0 && _y == -0) {
            _selectedDevice!.send("DRIVE,0,0|E");
            // send the command for 2 seconds every 0.5 seconds
            Future.delayed(Duration(seconds: 1), () {
              _selectedDevice!.send("DRIVE,0,0|E");
            }).then((value) => Future.delayed(Duration(seconds: 1), () {
                  _selectedDevice!.send("DRIVE,0,0|E");
                }));
          } else if (_x == -0) {
            // check if y is positive or negative
            if (_y > 0) {
              if (_previousCommand != "DRIVE,1,${_y.toInt()}|E") {
                _previousCommand = "DRIVE,1,${_y.toInt()}|E";
              }
            } else {
              if (_previousCommand != "DRIVE,2,${_y.toInt()}|E") {
                _previousCommand = "DRIVE,2,${_y.toInt()}|E";
              }
            }
          } else {
            // check if x is positive or negative
            if (_x > 0) {
              if (_previousCommand != "DRIVE,3,${_x.toInt()}|E") {
                _previousCommand = "DRIVE,3,${_x.toInt()}|E";
              }
            } else {
              if (_previousCommand != "DRIVE,4,${_x.toInt()}|E") {
                _previousCommand = "DRIVE,4,${_x.toInt()}|E";
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
    Duration t = Duration(milliseconds: 100);
      timer = Timer.periodic(t, (timer) {
        if (_selectedDevice != null) {
          _bluetoothHeartbeat();
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
              child: _joyStick(),
            ),
          ],
        ),
      ),
    );
  }
}
