import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_loading/rive_loading.dart';
import '../../basemodules/bluetooth/useBLE.dart';

var bleHandler = BluetoothHandler();

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimation createState() => _LoadingAnimation();
}

class _LoadingAnimation extends State<LoadingAnimation> {
  bool _isLoading = true;

  void callback(b) {
    if (b == true) {
      Navigator.pushReplacementNamed(context, '/HomePage');
    }
    if (b == false) {
      Navigator.pushReplacementNamed(context, '/AllowPerms');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bleHandler.requestPermissions(callback);
    return Scaffold(
      // run code on load

      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RiveLoading(
                      // width and height are the full  width and height of the screen
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      name: 'lib/mainapp/newusers/loading.riv',
                      loopAnimation: 'Timeline 1',
                      isLoading: _isLoading,
                      onSuccess: (_) {
                        print('Finished');
                      },
                      onError: (err, stack) {
                        print(err);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
