import 'package:flutter/material.dart';
import 'package:flutter_ble_scala/mainapp/newusers/PermissionsScreen.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import 'SendData.dart';

class FindDevices extends StatefulWidget {
  final Function(CustomBluetoothDevice) onDataSubmitted;

  FindDevices({required this.onDataSubmitted});

  @override
  AFindDevices createState() => AFindDevices(onDataSubmitted: onDataSubmitted);
}

class AFindDevices extends State<FindDevices> {
  Map<String, CustomBluetoothDevice> _devices = Map();

  final Function(CustomBluetoothDevice) onDataSubmitted;
  bool _isScanning = false;

  AFindDevices({required this.onDataSubmitted});

  void _addDevice(CustomBluetoothDevice device) {
    setState(() {
      _devices[device.getDeviceName()] = device;
    });
  }

  Widget _buildContainerDevice(device) {    
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        ElevatedButton(onPressed: () async {
          await device.connect();
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
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0x00ffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Devices found",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xff000000),
          ),
        ),
      ),
      body: Column(
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
          MaterialButton(
            onPressed: () async {
              if (_isScanning) {
                return;
              }
              _isScanning = true;
              await bleHandler.notEndingScan(_addDevice);
            },
            color: Color(0xff2641ff),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
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
            minWidth: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}
