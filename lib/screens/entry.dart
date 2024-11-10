import 'dart:io';

import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/controllers/app.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/widget/boundary.dart';
import 'package:msbm_assessment_test/controllers/navigation.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/screens/drive/entry.dart';
import 'package:msbm_assessment_test/screens/errors/not_found.dart';
import 'package:msbm_assessment_test/screens/widget/drawer.dart';
import 'package:msbm_assessment_test/screens/settings/entry.dart';
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

      case "exit_app":
        trayManager.destroy();
        exit(0);

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //? Obtain the data needed to render this page.
    final size = MediaQuery.sizeOf(context);

    //? Build and return the widget.
    return InterceptorBoundary(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? First, for the left hand side.
              SizedBox(
                width: size.width * 0.20,
                child: const NavigationDrawerWidget(),
              ),

              //? Second, for the main content...
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: ValueListenableBuilder(
                    valueListenable: AppRegistry.find<NavigationController>(),
                    builder: (context, value, child) => switch (value) {
                      0 => const DriveScreen(),
                      1 => const SettingsScreen(),
                      _ => const NotFoundScreen(),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
