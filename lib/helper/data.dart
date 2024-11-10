import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:msbm_assessment_test/controllers/app.dart';
import 'package:msbm_assessment_test/controllers/filesystem.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/images.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_launcher/url_launcher.dart';

/// A class that models the device specifications of this device that is the
/// client which is connecting to the
class DeviceSpecifications {
  /// The information of this device that is already cached in memory.
  static DeviceSpecifications? _current;

  /// The model of this device.
  final String model;

  /// The manufacturer of this device.
  final String manufacturer;

  /// Any value that can be unique to this app on this device.
  final String? serial;

  /// What kind of device is this?
  final String type;

  /// What should we say is this device's user agent?
  final String agent;

  /// Helper function used to get the current device specifications.
  static DeviceSpecifications get current => _current!;

  /// This is fair enough.
  const DeviceSpecifications({
    required this.model,
    required this.manufacturer,
    required this.serial,
    required this.type,
    required this.agent,
  });

  Map<String, dynamic> toSavedState(String userId) {
    return {
      "manufacturer": manufacturer,
      "owner": userId,
      "serial": serial,
      "agent": agent,
      "type": type,
      "name": model,
      "timestamp": DateTime.now().millisecondsSinceEpoch // Basically some UNIX timestamp.
    };
  }

  String toHTTPHeader(String userId, String token) {
    return encrypt(token, jsonEncode(toSavedState(userId)));
  }
}

/// A utility function used to get the specifications of the device that is
/// sending any and all requests to the server side.
Future<DeviceSpecifications> getDeviceData() async {
  //? Only do this when the device specifications are not already retrieved...
  if (DeviceSpecifications._current == null) {
    var deviceInfo = DeviceInfoPlugin();

    //? If this is a MacBook...
    if (Platform.isMacOS) {
      final macOsDeviceInfo = await deviceInfo.macOsInfo;

      // Return these device specifications.
      DeviceSpecifications._current = DeviceSpecifications(
        model: "${macOsDeviceInfo.model} ${macOsDeviceInfo.osRelease}",
        manufacturer: "Apple Inc.",
        serial: macOsDeviceInfo.systemGUID ?? macOsDeviceInfo.data.toString(),
        type: macOsDeviceInfo.model,
        agent:
            "${macOsDeviceInfo.computerName}/${macOsDeviceInfo.hostName}/${macOsDeviceInfo.model}::${macOsDeviceInfo.osRelease}",
      );
    }

    //? If this is a windows computer...
    if (Platform.isWindows) {
      //? Else, we return linux device specifications.
      final windowsDevInfo = await deviceInfo.windowsInfo;

      // Return these device specifications.
      DeviceSpecifications._current = DeviceSpecifications(
        model: "${windowsDevInfo.productName} ${windowsDevInfo.buildNumber}",
        manufacturer: "${windowsDevInfo.productType} ${windowsDevInfo.productName}",
        serial: windowsDevInfo.deviceId,
        type: windowsDevInfo.productName,
        agent:
            "${windowsDevInfo.computerName}/${windowsDevInfo.productName}/${windowsDevInfo.buildNumber} ${windowsDevInfo.userName}/${windowsDevInfo.productId}/${windowsDevInfo.deviceId}",
      );
    }

    //? Else, we return linux device specifications.
    final linuxDeviceInfo = await deviceInfo.linuxInfo;

    // Return these device specifications.
    DeviceSpecifications._current = DeviceSpecifications(
      model: linuxDeviceInfo.prettyName,
      manufacturer: linuxDeviceInfo.prettyName,
      serial: linuxDeviceInfo.machineId ?? linuxDeviceInfo.buildId,
      type: linuxDeviceInfo.name,
      agent:
          "${linuxDeviceInfo.id}/${linuxDeviceInfo.variantId}/${linuxDeviceInfo.versionId} ${linuxDeviceInfo.prettyName}/${linuxDeviceInfo.machineId}",
    );
  }

  // Return this because we have built it.
  return DeviceSpecifications._current!;
}

/// A utility function used to get a JWT from a given text using a key and a pay-
/// load. This is typically used to encrypt information on behalf of the admin
/// currently logged into the device.
String encrypt(String key, String payload) {
  // Create the new JSON web token
  final value = JWT(payload);

  // Return the signed value.
  return value.sign(SecretKey(key));
}

/// A utility function used to decrypt a JWT cipher using the key that was passed
/// to it. This is usually used to decode text on behalf of this user that was
/// stored somewhere on his or her behalf.
String decrypt(String key, String cipher) {
  try {
    final value = JWT.verify(cipher, SecretKey(key));
    return value.payload;
  } catch (_) {
    return "?";
  }
}

/// A utility function used to obtain the hash for a given string. This is used
/// to locally store the admin's OTP.
String hash(String payload) {
  return sha512.convert(utf8.encode(payload)).toString();
}

/// A utility function used to
Future<void> initializeTray() async {
  //? First, set the right icon.
  await trayManager.setIcon(
    Platform.isWindows ? Images.launcherIconWindows : Images.launcherIcon,
  );

  //? Second, we use this to check if the sync folder already exists.
  final driveFolder = await AppRegistry.find<FilesystemController>().driveDirectory;
  final syncExists = await driveFolder.exists();

  //? This is the menu we are using...
  Menu menu = Menu(
    items: [
      //* Only show this entire region if the sync folder exists...
      if (syncExists) ...[
        //? First, the option to go to the sync folder.
        MenuItem(
          key: 'open_drive',
          label: 'Open Sync Folder',
          onClick: (item) => launchUrl(driveFolder.uri),
        ),

        //? Second, the option to sync the folder now.
        MenuItem(
          key: 'sync_drive',
          label: 'Sync Now',
          onClick: (item) => AppRegistry.find<FilesystemController>().silentSyncChanges(),
        ),

        //? Second, the option to sync the folder now.
        MenuItem(
          key: 'toggle_usb_devices',
          label: 'Enable/Disable USB Devices',
          onClick: (item) => AppRegistry.find<AppController>().toggleUSBDevices(),
        ),

        // Finally, a separator.
        MenuItem.separator(),
      ],

      //? First, for the how button...
      MenuItem(
        key: 'show_window',
        label: 'Show/Hide Window',
      ),

      //? Finally, for exiting the app.
      MenuItem(
        key: 'exit_app',
        label: 'Exit App',
      ),
    ],
  );

  //? Use this context menu.
  await trayManager.setContextMenu(menu);
}
