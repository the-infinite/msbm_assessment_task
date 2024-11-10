import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:msbm_assessment_test/core/base.dart';

class NotificationHelper {
  NotificationHelper._();

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
}
