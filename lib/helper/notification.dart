import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:msbm_assessment_test/helper/images.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';
import 'package:msbm_assessment_test/core/base.dart';

class NotificationHelper {
  NotificationHelper._();

// Create an instance of Windows Notification with your application name
// application id must be null in packaged mode
  static final _winNotifyPlugin = WindowsNotification(
      applicationId: "rD65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}\\WindowsPowerShell\v1.0\\powershell.exe");

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationsSettings = InitializationSettings(
      linux: LinuxInitializationSettings(
        defaultActionName: "msbm_assessment_task",
      ),
      macOS: DarwinInitializationSettings(),
    );

    //? Request the notification permissions.
    if (Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions();
    }

    //!.requestPermission();
    final result = await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
    );

    //? This is fine too
    if (result == true) {
      AppRegistry.debugLog("Notifications plugin initialized successfully", "Helpers.Notify");
    }

    //? Failed.
    else {
      AppRegistry.debugLog("Failed to initialize notifications plugin.", "Helpers.Notify");
    }
  }

  static Future<void> sendNotification(
    String body, [
    String title = "MSBM Drive",
    FlutterLocalNotificationsPlugin? fln,
    dynamic notificationBody,
  ]) async {
    //? Send this like this if this is the WIndows platform.
    if (Platform.isWindows) {
      _sendWindowsNotification(body, title, notificationBody);
      return;
    }

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      linux: LinuxNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
    await FlutterLocalNotificationsPlugin().show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: notificationBody != null ? jsonEncode(notificationBody.toSavedState()) : null,
    );
  }

  static Future<void> _sendWindowsNotification(
    String body, [
    String title = "MSBM Drive",
    dynamic notificationBody,
  ]) async {
    // create new NotificationMessage instance with id, title, body, and images
    NotificationMessage message = NotificationMessage.fromPluginTemplate(
      "notification.${DateTime.now().millisecondsSinceEpoch}",
      title,
      body,
      largeImage: Images.launcherIconWindows,
      image: Images.launcherIconWindows,
    );

    // show notification
    _winNotifyPlugin.showNotificationPluginTemplate(message);
  }
}
