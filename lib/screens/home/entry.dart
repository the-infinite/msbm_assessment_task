import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/controllers/app.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/widget/boundary.dart';
import 'package:tray_manager/tray_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case "show_window":
        AppRegistry.find<AppController>().toggleWindow();
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InterceptorBoundary(
      canPop: false,
      child: Scaffold(
        body: Placeholder(),
      ),
    );
  }
}
