import 'package:flutter_ble_scala/mainapp/normal/HomePage.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/material.dart';
import 'FindDevices.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import 'package:flutter/services.dart';

const ballSize = 20.0;
const step = 10.0;




class AJoystick extends StatefulWidget {
  const AJoystick({Key? key}) : super(key: key);

  @override
  _Joystick createState() => _Joystick();
}

class _Joystick extends State<AJoystick> {
  bool a = false;
  double _x = 100;
  double _y = 100;
  CustomBluetoothDevice? _selectedDevice;

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
          setState(() {
            _x = _x + step * details.x;
            _y = _y + step * details.y;
          });
        },
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          _openSecondScreen();
        }, 
        child: Text("Select Device")
      );
    }
  }

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (a == false) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
    a = true;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Drive your leaphy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AHomeScreen()));
          },
        )
      ),
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

