library easy_permission_validator;

import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_popup.dart';

class EasyPermissionValidator {
  /// App title to show in the standard popup
  String appName;

  /// You can change the standard popup if you need
  Widget? customDialog;

  BuildContext context;

  /// App title Color to show in the standard popup
  Color? appNameColor;

  /// Optional in case you need to use other languages
  String? goToSettingsText;

  /// Optional in case you need to use other languages
  String? cancelText;

  /// Optional in case you need to use other languages
  String? enableLocationMessage;

  String? permissionSettingsMessage;

  EasyPermissionValidator({
    required this.context,
    required this.appName,
    this.customDialog,
    this.appNameColor,
    this.cancelText,
    this.enableLocationMessage,
    this.goToSettingsText,
    this.permissionSettingsMessage,
  });

  Future<bool> contacts() async {
    return await _validatePermission(Permission.contacts);
  }

  Future<bool> calendar() async {
    return await _validatePermission(Permission.calendar);
  }

  Future<bool> camera() async {
    return await _validatePermission(Permission.camera);
  }

  Future<bool> phone() async {
    return await _validatePermission(Permission.phone);
  }

  Future<bool> reminders() async {
    return await _validatePermission(Permission.reminders);
  }

  Future<bool> sensors() async {
    return await _validatePermission(Permission.sensors);
  }

  Future<bool> storage() async {
    if (io.Platform.isAndroid) {
      return await _validatePermission(Permission.storage);
    }
    return true;
  }

  Future<bool> microphone() async {
    return await _validatePermission(Permission.microphone);
  }

  Future<bool> speech() async {
    return await _validatePermission(Permission.speech);
  }

  Future<bool> photos() async {
    return await _validatePermission(Permission.photos);
  }

  Future<bool> mediaLibrary() async {
    return await _validatePermission(Permission.mediaLibrary);
  }

  /// The best option for LOCATION request
  Future<bool> location() async {
    return await _validatePermission(Permission.location);
  }

  Future<bool> locationAlways() async {
    return await _validatePermission(Permission.locationAlways);
  }

  Future<bool> locationWhenInUse() async {
    return await _validatePermission(Permission.locationWhenInUse);
  }

  Future<bool> sms() async {
    if (io.Platform.isAndroid) {
      return await _validatePermission(Permission.sms);
    }
    return true;
  }

  Future<bool> bluetooth() async {
    return await _validatePermission(Permission.bluetooth);
  }

  Future<bool> bluetoothScan() async {
    return await _validatePermission(Permission.bluetoothScan);
  }

  Future<bool> bluetoothAdvertise() async {
    return await _validatePermission(Permission.bluetoothAdvertise);
  }

  Future<bool> bluetoothConnect() async {
    return await _validatePermission(Permission.bluetoothConnect);
  }

  Future<bool> appTrackingTransparency() async {
    return await _validatePermission(Permission.appTrackingTransparency);
  }

  Future<bool> criticalAlerts() async {
    return await _validatePermission(Permission.criticalAlerts);
  }

  Future<bool> notification() async {
    return await _validatePermission(Permission.notification);
  }

  Future<bool> accessNotificationPolicy() async {
    return await _validatePermission(Permission.accessNotificationPolicy);
  }

  Future<bool> requestInstallPackages() async {
    return await _validatePermission(Permission.requestInstallPackages);
  }

  Future<bool> systemAlertWindow() async {
    return await _validatePermission(Permission.systemAlertWindow);
  }

  Future<bool> manageExternalStorage() async {
    return await _validatePermission(Permission.manageExternalStorage);
  }

  Future<bool> ignoreBatteryOptimizations() async {
    return await _validatePermission(Permission.ignoreBatteryOptimizations);
  }

  Future<bool> activityRecognition() async {
    return await _validatePermission(Permission.activityRecognition);
  }

  Future<bool> _validatePermission(Permission permissionGroup) async {
    PermissionStatus status = await permissionGroup.request();
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.permanentlyDenied:
        _showPermissionPopup(status: status);
        return false;
      case PermissionStatus.denied:
        return false;
      default:
        return false;
    }
  }

  _showPermissionPopup({PermissionStatus? status}) {
    PermissionPopup(
      appNameColor: appNameColor,
      cancelText: cancelText,
      enableLocationMessage: enableLocationMessage,
      goToSettingsText: goToSettingsText,
      permissionSettingsMessage: permissionSettingsMessage,
      context: context,
      appName: appName,
      customDialog: customDialog,
    ).show(status: status);
  }
}