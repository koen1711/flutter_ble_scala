import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';

// make a function that initiates all child functions

class BluetoothHandler {
  // add a class function

  // make async function
  Future<bool> checkPermissions() async {
    List<bool> list = [];

    list.add(await Permission.locationWhenInUse.status.isGranted);
    list.add(await Permission.bluetooth.status.isGranted);
    list.add(await Permission.bluetoothAdvertise.status.isGranted);
    list.add(await Permission.bluetoothConnect.status.isGranted);
    list.add(await Permission.bluetoothScan.status.isGranted);


    return (list.contains(false) ? false : true);
  }

  Future<void> requestPermissions() async {
    // Check for permissions
    if (await checkPermissions() == true) {
      return;
    }

    
    await Permission.locationWhenInUse.status.then((status) {
      if (status.isRestricted || status.isDenied) {
        Permission.locationWhenInUse.request();
      }
    });
    // wait for request 1 to be finished



    await Permission.bluetooth.status.then((status) {
      if (status.isRestricted || status.isDenied) {
        Permission.bluetooth.request();
      }
    });
    await Permission.bluetoothAdvertise.status.then((status) {
      if (status.isRestricted || status.isDenied) {
        Permission.bluetoothAdvertise.request();
      }
    });
    await Permission.bluetoothConnect.status.then((status) {
      if (status.isRestricted || status.isDenied) {
        Permission.bluetoothConnect.request();
      }
    });

    await Permission.bluetoothScan.status.then((status) {
      if (status.isRestricted || status.isDenied) {
        Permission.bluetoothScan.request();
      }
    });
  }

  Future<bool?> checkBluetooth() async {
    // Check if bluetooth is enabled
    return await FlutterBluetoothSerial.instance.isEnabled;
  }

  Future<void> enableBluetooth() async {
    // Enable bluetooth
    await FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<void> disableBluetooth() async {
    // Disable bluetooth
    await FlutterBluetoothSerial.instance.requestDisable();
  }

  Future<List> scanDevices() async {
    // Scan for devices and get a list of the devices
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    // scan for devices for 10 seconds
    var tmp = new Map<String, BluetoothDiscoveryResult>();

    FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      if (r.device.name != null) {
        if (tmp.containsKey(r.device.address)) {
          FlutterBluetoothSerial.instance.cancelDiscovery();
        }
        tmp.putIfAbsent(r.device.address, () => r);
      }
    });

    // wait for 10 seconds
    await Future.delayed(Duration(seconds: 10));

    // get the result of a (FlutterBluetoothSerial.instance.startDiscovery())
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    var re_list = [];
    for (var i in tmp.values) {
      re_list.add(CustomBluetoothDevice(i));
    }
    await re_list[0].connect();

    re_list[0].send("Hello, World!");

    return re_list;
  }
}

// add a variable data to the ArduinoBluetoothDevice class
class CustomBluetoothDevice {
  // add a constructor
  CustomBluetoothDevice(this.data);

  var data;
  var con;

  String getDeviceName() {
    return data.device.name;
  }

  String getDeviceAddress() {
    return data.device.address;
  }

  Future<bool> connect() async {
    con = await BluetoothConnection.toAddress(getDeviceAddress());
    if (con.toString() == "Instance of 'BluetoothConnection'") {
      return true;
    } else {
      return false;
    }
  }

  void disconnect() {
    // disconnect from device
    if (con != null) {
      con.close();
      con = null;
    }
  }

  void send(String data) {
    // send data to device
    if (con != null) {
      con.output.add(utf8.encode(data));
    } else {}
  }
}
