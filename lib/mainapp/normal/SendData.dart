import 'package:flutter/material.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import 'FindDevices.dart';

class ASendData extends StatefulWidget {
  ASendData({CustomBluetoothDevice? device});

  @override
  _SendData createState() => _SendData();
}

class _SendData extends State<ASendData> with WidgetsBindingObserver {
  _SendData({CustomBluetoothDevice? device});

  var bleHandler = BluetoothHandler();
  // make the two states
  List<Map> _data = [];
  List<CustomBluetoothDevice> _devices = [];
  CustomBluetoothDevice? _selectedDevice;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _selectedDevice?.connect();
        bleHandler.stopNotEndingRecieving(_selectedDevice!);
        break;
      case AppLifecycleState.paused:
        _selectedDevice?.disconnect();
        bleHandler.notEndingRecieving(_selectedDevice!, _recieveData);
        break;
      default:
        break;
    }
  }

  void _recieveData(String devicename, String data) {
    setState(() {
      _data.add({"$devicename": data});
    });
  }

  void _sendData(String devicename, String data) {
    setState(() {
      if (_selectedDevice != null) {
        _data.add({"You": data});
        print("You: $_data");
        _selectedDevice?.send(data);
      }
    });
  }

  Widget _blueTexts(Map data) {
    return Container(
      margin: EdgeInsets.fromLTRB(80, 0, 16, 0),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xff3a57e8),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
            bottomRight: Radius.circular(6.0)),
      ),
      child: Text(
        "${data.keys.first}: ${data.values.first}",
        textAlign: TextAlign.start,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 12,
          color: Color(0xffffffff),
        ),
      ),
    );
  }

  Widget _greyTexts(Map data) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 80, 0),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
            bottomRight: Radius.circular(6.0)),
      ),
      child: Text(
        "${data.values.first}",
        textAlign: TextAlign.start,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 12,
          color: Color(0xff000000),
        ),
      ),
    );
  }

  Widget _textField() {
    if (_selectedDevice == null) {
      return ElevatedButton(
          onPressed: () {
            _openSecondScreen();
          },
          child: Text("Select Device"));
    }
    bleHandler.notEndingRecieving(_selectedDevice!, _recieveData);
    return TextField(
      controller: _textController,
      obscureText: false,
      textAlign: TextAlign.start,
      maxLines: 1,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 14,
        color: Color(0xff000000),
      ),
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Color(0xffffffff), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Color(0xffffffff), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Color(0xffffffff), width: 1),
        ),
        hintText: "Type something...",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 14,
          color: Color(0xff000000),
        ),
        filled: true,
        fillColor: Color(0xffffffff),
        isDense: false,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  Widget _buildTexts() {
    // loop through the data and build the texts
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        if (_data[index].keys.first == "You") {
          return _blueTexts(_data[index]);
        } else {
          return _greyTexts(_data[index]);
        }
      },
    );
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

  @override
  Widget build(BuildContext context) {
    // check if any device is connected
    return Scaffold(
        backgroundColor: Color(0xffebebeb),
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffffffff),
          shape: RoundedRectangleBorder(),
          leading: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xffffffff),
              shape: RoundedRectangleBorder(),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xff212435),
              size: 24,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: _buildTexts(),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _textField(),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _sendData("You", _textController.text);
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                          padding: EdgeInsets.all(0),
                          width: 40,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xff3a57e8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xffffffff),
                            size: 18,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
