import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

void requestPermissions() async {
  bool reqSuc = false;
  List<Permission> permissions = [
    Permission.storage,
  ];

  for (Permission permission in permissions) {
    if (await permission.isGranted) {
      if (kDebugMode) {
        print("Permission: $permission already granted");
      }
      reqSuc = true;
      continue;
    } else if (await permission.isDenied) {
      PermissionStatus permissionsStatus = await permission.request();
      if (permissionsStatus.isGranted) {
        if (kDebugMode) {
          print("Permission: $permission already granted");
        }
        reqSuc = true;
      } else if (permissionsStatus.isPermanentlyDenied) {
        if (kDebugMode) {
          print("Permission: $permission is permanently denied");
        }
        reqSuc = false;
      }
    }
  }
  if (reqSuc == false) {
    openAppSettings();
  }
}
