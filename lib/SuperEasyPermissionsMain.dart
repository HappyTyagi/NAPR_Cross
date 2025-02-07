import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../thems.dart';
import 'package:permission_handler/permission_handler.dart';


/// Permission constants for android and ios
enum Permissions {
  /// Android: Allows an application to access any geographic locations
  /// persisted in the user's shared collection.
  accessMediaLocation,

  /// Android: Camera iOS: Photos (Camera Roll and Camera)
  camera,

  /// Android: None iOS: MPMediaLibrary
  mediaLibrary,

  /// Android: Nothing iOS: Photos iOS 14+ read & write access level
  photos,

  /// Android: Nothing iOS: Photos iOS 14+ read & write access level
  photosAddOnly,

  /// Android: External Storage iOS: Access to folders like Documents
  ///  or Downloads. Implicitly granted.
  storage,

  ///Location
  location
}

class SuperEasyPermissionsMain {
  /// Asks(request) for permission and return true if granted, otherwise returns false.
  /// If the permission is permanently denied, This will open the settings
  static Future<bool> askPermission(Permissions permission) async {
    int result = await getPermissionResult(permission);
    var permissionName = _getEquivalentPermissionName(permission);
    print(permissionName);
    if (result == 0) {
      // Code for deny (false)
      var status = await permissionName!.request();
      return status == PermissionStatus.granted || status == PermissionStatus.limited;
    } else if (result == -1) {
      // Code for notAgain (false)
      await openAppSettings();
      result = await getPermissionResult(permission);
      return result == 1;
    } else {
      // already granted
      return true;
    }
  }

  /// returns true if permission is granted, otherwise return false
  static Future<bool> isGranted(Permissions permission) async {
    return (await getPermissionResult(permission)) == 1;
  }

  /// returns true if permission is temporary or permanently denied, otherwise returns false.
  static Future<bool> isDenied(Permissions permission) async {
    return (await getPermissionResult(permission)) != 1;
  }

  /// returns true if permission is permanently denied, otherwise return false
  static Future<bool> isPermanentlyDenied(Permissions permission) async {
    return (await getPermissionResult(permission)) == -1;
  }

  /// Return 1 if permission is granted,
  /// return 0 if denied,
  /// return -1 if user set to don't ask again
  static Future<int> getPermissionResult(Permissions permission) async {
    var permissionName = _getEquivalentPermissionName(permission)!;
    var permissionStatus = await permissionName.status;
    int result;
    if (permissionStatus == PermissionStatus.granted) {
      result = 1;
    } else if (permissionStatus == PermissionStatus.limited) {
      result = 1;
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      result = -1;
    } else {
      result = 0;
    }
    return result;
  }

  static Permission? _getEquivalentPermissionName(Permissions permissionName) {
    var map = <Permissions, Permission>{
      Permissions.accessMediaLocation: Permission.accessMediaLocation,
      Permissions.camera: Permission.camera,
      Permissions.mediaLibrary: Permission.mediaLibrary,
      Permissions.photos: Permission.photos,
      Permissions.photosAddOnly: Permission.photosAddOnly,
      Permissions.storage: Permission.storage,
      Permissions.location: Permission.location,
    };
    return map[permissionName];
  }
}