import 'dart:ffi';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';

// make a function that initiates all child functions

class BluetoothHandler {
  // add a class function
  // make async function
  bool _isScanning = false;
  Map<CustomBluetoothDevice, bool> _isRecieving = {};

  Future<bool> checkPermissions() async {
    List<bool> list = [];

    list.add(await Permission.locationWhenInUse.status.isGranted);
    list.add(await Permission.bluetooth.status.isGranted);
    list.add(await Permission.bluetoothAdvertise.status.isGranted);
    list.add(await Permission.bluetoothConnect.status.isGranted);
    list.add(await Permission.bluetoothScan.status.isGranted);

    return (list.contains(false) ? false : true);
  }

  Future<void> requestPermissions(cb) async {
    // Check for permissions
    if (await checkPermissions() == true) {
      return cb(true);
    }

    var list = [];

    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      //add more permission to request here.
    ].request();

    if (await checkPermissions() == true) {
      return cb(true);
    }
    return cb(false);
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
    _isScanning = true;
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
    _isScanning = false;
    return re_list;
  }

  Future<void> stopNotEndingScan() async {
    _isScanning = false;
    await FlutterBluetoothSerial.instance.cancelDiscovery();
  }

  Future<void> stopNotEndingRecieving(CustomBluetoothDevice device) async {
    _isRecieving[device] = false;
    device.con!.finish();
    device.connect();
  }

  Future<void> notEndingScan(cb) async {
    _isScanning = true;
    // Scan for devices and get a list of the devices
    await FlutterBluetoothSerial.instance.cancelDiscovery();

    if (await checkBluetooth() == false) {
      await enableBluetooth();
    }

    FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      if (r.device.name != null) {
        cb(CustomBluetoothDevice(r));
      }
    }).onDone(() {
      // keep on scanning for devices
      if (_isScanning == true) {
        notEndingScan(cb);
      }
    });
    _isScanning = false;
  }

  Future<void> notEndingRecieving(CustomBluetoothDevice device, cb) async {
    if (_isRecieving == false) {
      _isRecieving[device] = true;
      // Recieve data from a device
      device.con!.input!.listen((data) {
        cb(device.getDeviceName(), utf8.decode(data));
      }).onDone(() {
        // keep on recieving data
        if (_isRecieving[device] == true) {
          notEndingRecieving(device, cb);
        }
      });

      _isRecieving[device] = false;
    }
  }

  Future<void> breakAllConnections() async {
    // Recieve data from a device
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    await FlutterBluetoothSerial.instance.requestDisable();

    await FlutterBluetoothSerial.instance.requestEnable();
  }
}

// add a variable data to the ArduinoBluetoothDevice class
class CustomBluetoothDevice {
  // add a constructor
  CustomBluetoothDevice(this.data);

  var data;
  BluetoothConnection? con;

  String getDeviceName() {
    return data.device.name;
  }

  String getDeviceAddress() {
    return data.device.address;
  }

  Future<bool> connect() async {
    try {
      con = await BluetoothConnection.toAddress(getDeviceAddress());
    } catch (e) {
      return false;
    }
    if (con.toString() == "Instance of 'BluetoothConnection'") {
      return true;
    } else {
      con = null;
      return false;
    }
  }

  void disconnect() {
    // disconnect from device
    if (con != null) {
      con!.close();
      con = null;
    }
  }

  Future<bool> send(String data) async {
    // send data to device
    final Uint8List dataList = Uint8List.fromList(utf8.encode(data));
    if (con != null) {
      con!.output.add(dataList);
    } else {
      await connect();
      con!.output.add(dataList);
    }
    return true;
  }
}
