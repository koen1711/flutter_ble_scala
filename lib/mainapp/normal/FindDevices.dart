import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_scala/mainapp/newusers/PermissionsScreen.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import 'package:flutter/cupertino.dart';

class FindDevices extends StatefulWidget {
  final Function(CustomBluetoothDevice) onDataSubmitted;

  FindDevices({required this.onDataSubmitted});

  @override
  AFindDevices createState() => AFindDevices(onDataSubmitted: onDataSubmitted);
}

class AFindDevices extends State<FindDevices> with WidgetsBindingObserver {
  Map<String, CustomBluetoothDevice> _devices = Map();
  bool _isScanning = false;

  AFindDevices({required this.onDataSubmitted});

  final Function(CustomBluetoothDevice) onDataSubmitted;
  

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
        bleHandler.notEndingScan(_addDevice);
        break;
      case AppLifecycleState.paused:
        bleHandler.stopNotEndingScan();
        break;
      default:
        break;
    }
  }

  void _addDevice(CustomBluetoothDevice device) {
    setState(() {
      _devices[device.getDeviceName()] = device;
    });
  }

  Widget _buildButton() {
    if (_isScanning == true) {
      return MaterialButton(
        onPressed: () async {
          setState(() {
            _isScanning = false;
          });
          await bleHandler.stopNotEndingScan();
        },
        color: Color.fromARGB(255, 255, 38, 38),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Color(0xff808080), width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          "Stop Scanning",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        textColor: Color(0xff000000),
        height: MediaQuery.of(context).size.height * 0.05,
        minWidth: MediaQuery.of(context).size.width,
      );
    } else {
      return MaterialButton(
        onPressed: () async {
          setState(() {
            _isScanning = true;
          });
          await bleHandler.notEndingScan(_addDevice);
        },
        color: Colors.cyan,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Color(0xff808080), width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          "Start Scanning",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        textColor: Color(0xff000000),
        height: MediaQuery.of(context).size.height * 0.05,
        minWidth: MediaQuery.of(context).size.width / 1.2,
      );
    }
  }

  Widget _buildContainerDevice(device) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        ElevatedButton(
          onPressed: () async {
            // show that we are connecting
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Connecting to device"),
              ),
            );
            bool r = await device.connect();
            if (r == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Could not connect to device"),
                ),
              );

            }
            onDataSubmitted(device);
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(60, 0, 0, 0),
            padding: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            // height infinite because of the stack
            height: 130,
            decoration: BoxDecoration(
              color: Color(0xff3a57e8),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${device.getDeviceName()}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 12),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Tap to connect",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xffd4d4d4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        var device = _devices.values.elementAt(index);
        return _buildContainerDevice(device);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (context) => Builder(
              builder: (context) => CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    leading: Container(), middle: Text('Quick Commands')),
                child: SafeArea(
                    bottom: false,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildListView(),
                          ),
                        ],
                      ),
                    ),
                    _buildButton(),
                  ],
                ),
                )
              ),
            ),
          ),
        ),
      ),                                              
    );
  }
}
