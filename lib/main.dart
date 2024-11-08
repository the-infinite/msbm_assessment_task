import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:msbm_assessment_test/app.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/data.dart';
import 'package:msbm_assessment_test/helper/notification.dart';
import 'package:msbm_assessment_test/helper/registry.dart';
import 'package:msbm_assessment_test/helper/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is fair enough.
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _startAppState() async {}

Future<void> main() async {
  // First, set the URL strategy.
  HttpOverrides.global = MyHttpOverrides();

  // Second, preserve the native splash screen.
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  // Get the specifications of this device.
  await getDeviceData();

  // Third, initialize the app registry.
  await AppRegistry.initialize(
    routeHandler: RouteHelper.routeHandler,
    onLoggerFull: (logs) {
      AppRegistry.debugLog(logs);
    },
  );

  // Fourth, configure the environment properly.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Try to handle it.
  try {
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  }

  // This is fine.
  catch (e) {
    AppRegistry.debugLog("Unable to start notifications: $e");
  }

  // Handle the entry into the app from the order now button.
  await RegistryHelper.init();

  //? Now, clear this out.
  try {
    await _startAppState();
  } catch (e) {
    await AppRegistry.find<SharedPreferences>().clear();
    AppRegistry.debugLog(e, "Startup.Error");
  }

  // Run the app.
  runApp(const MyApp()); // Run the app.
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
