import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/images.dart';
import 'package:msbm_assessment_test/helper/notification.dart';
import 'package:msbm_assessment_test/models/app.dart';
import 'package:msbm_assessment_test/repositories/app.dart';
import 'package:tray_manager/tray_manager.dart';

class AppController extends StateController<AppModel, AppRepository> {
  bool _isWindowShowing = true;
  bool _usbStatus = true;

  // Construct.
  AppController({required super.repo}) {
    initialize(null);
  }

  /// Controller utility used to toggle the state of the window.
  void toggleWindow() {
    //? If this window is showing...
    if (_isWindowShowing) {
      _isWindowShowing = false;
      appWindow.hide();
    }

    //? Since this window is not yet visible.
    else {
      _isWindowShowing = true;
      appWindow.show();
    }
  }

  /// Controller utility used to send a notification using the underlying
  /// platform's notification pipeline.
  Future<void> sendNotification(
    String body, [
    String title = "MSBM Drive",
    dynamic notificationBody,
  ]) {
    //? If the app is not showing...
    if (_isWindowShowing) return Future.value(null);

    //? Now, to send a notification on Windows...
    if (Platform.isWindows) {
      //
    }

    //? Send for linux and macOS.
    return NotificationHelper.sendNotification(
      body,
      title,
      null,
      notificationBody,
    );
  }

  /// Controller utility used to set the system tray icon to the loading icon.
  void setSyncingState() {
    trayManager.setIcon(AppIcons.stateSyncing);
    trayManager.setTitle("Syncing drive...");
    if (!Platform.isLinux) trayManager.setToolTip("Syncing drive...");
  }

  /// Controller utility used to set the system tray icon to the icon used when
  /// loading has been completed.
  void setSyncingFinishedState() {
    trayManager.setIcon(AppIcons.stateLoaded);
    trayManager.setTitle("All files synced!");
    if (!Platform.isLinux) trayManager.setToolTip("All files synced!");
  }

  /// Controller utility used to set the system tray icon to the icon used when
  /// by default in the app.
  void setSyncingNoneState() {
    trayManager.setIcon(
      Platform.isWindows ? Images.launcherIconWindows : Images.launcherIcon,
    );
    trayManager.setTitle("");
    if (!Platform.isLinux) trayManager.setToolTip("MSBM Assessment Task");
  }

  /// Controller utility used to set the system tray icon to show that USB access
  /// is now blocked.
  void setUSBDisabledState() {
    _usbStatus = false;
    trayManager.setIcon(AppIcons.usbDisabled);
    trayManager.setTitle("USB Access Blocked");
    sendNotification("Use of USB ports have been disabled");
    if (!Platform.isLinux) trayManager.setToolTip("USB Access Blocked");
  }

  /// Controller utility used to set the system tray icon to show that USB access
  /// is now blocked.
  void setUSBEnabledState() {
    _usbStatus = true;
    trayManager.setIcon(AppIcons.usbEnabled);
    trayManager.setTitle("USB Access Allowed");
    sendNotification("Use of USB ports have been enabled");
    if (!Platform.isLinux) trayManager.setToolTip("USB Access Allowed");
  }

  /// Controller utility used toggle the status of USB devices. When this is
  /// enabled, so are USB devices.
  void toggleUSBDevices() {
    _usbStatus ? setUSBDisabledState() : setUSBEnabledState();
    Future.delayed(const Duration(seconds: 2), setSyncingNoneState);
  }
}
