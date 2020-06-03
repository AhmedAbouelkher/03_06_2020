// import 'package:permission_handler/permission_handler.dart';

// class Permissions {
//   /// Check a [permission] and return a [Future] with the result
//   static Future<PermissionStatus> checkPermissionStatus(PermissionGroup permissionGroup) async {
//     return await PermissionHandler()
//         .checkPermissionStatus(permissionGroup);
//   }

//   /// Request a [permission] and return a [Future] with the result
//   static Future<Map<PermissionGroup, PermissionStatus>>
//       requestPermissions(List<PermissionGroup> permissionGroups) async {
//     return await PermissionHandler()
//         .requestPermissions(permissionGroups);
//   }

//   ///Checking the service status only makes sense for the PermissionGroup.
//   ///location on Android and the PermissionGroup.location, PermissionGroup.locationWhenInUser, PermissionGroup.locationAlways or
//   ///PermissionGroup.sensors on iOS.
//   /// All other permission groups are not backed by a separate service and will always return ServiceStatus.notApplicable
//   static Future<ServiceStatus> checkServiceStatus() async {
//     return await PermissionHandler()
//         .checkServiceStatus(PermissionGroup.location);
//   }

//   static Future<bool> openAppSettings() async {
//     return await PermissionHandler().openAppSettings();
//   }
// }
