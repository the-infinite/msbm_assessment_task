import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:msbm_assessment_test/controllers/theme.dart';
import 'package:msbm_assessment_test/core/state/single_subscriber.dart';
import 'package:flutter/gestures.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/models/theme.dart';
import 'package:msbm_assessment_test/helper/route.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';

bool _opened = false;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initialize the state of the app.
    initializeAppState();
  }

  void initializeAppState() async {
    // This is fine.
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // After the first time this opens up...
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        //! Break when already opened.
        if (_opened) return;

        //! If this is not the initial route, leave.
        if (AppRegistry.currentRoute != RouteHelper.getInitialRoute()) return;

        // Set this flag.
        _opened = true;

        // Circle back to the initial route.
        AppRegistry.nav.pushNamedAndRemoveUntil(RouteHelper.getInitialRoute(), (route) => false);
      },
    );

    // Return the widget we need here.
    return SingleStateSubscriberWidget<ThemeController, ThemeState>(
      builder: (controller, state) {
        return KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            //* Well, we use the escape key to navigate backward.
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              AppRegistry.nav.maybePop();
            }
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
              ),
              theme: state?.value,
              initialRoute: RouteHelper.getInitialRoute(),
              navigatorKey: AppRegistry.navigatorKey,
              onGenerateRoute: AppRegistry.onRouteGenerated,
              builder: (context, widget) {
                return Material(
                  child: widget!,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
