import 'package:flutter/material.dart';
import 'package:flutter_ble_scala/mainapp/newusers/PermissionsScreen.dart';
import '../../basemodules/bluetooth/useBLE.dart';
import 'AgreementScreen.dart';
import 'WelcomeScreen.dart';
import 'License.dart';

class AgreementScreen extends AAgreementScreen {}

class WelcomeScreen extends AWelcomeScreen {}

class PermissionScreen extends LoadingAnimation {}

class License extends ALicense {
  License(String licenseText) : super(licenseText);
}