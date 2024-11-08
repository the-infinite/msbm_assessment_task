import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/screens/auth/login.dart';
import 'package:msbm_assessment_test/screens/auth/register.dart';
import 'package:msbm_assessment_test/screens/home/entry.dart';
import 'package:msbm_assessment_test/screens/not_found.dart';
import 'package:msbm_assessment_test/screens/settings/entry.dart';
import 'package:msbm_assessment_test/screens/welcome.dart';

class RouteHelper {
  // Construct.
  RouteHelper._();

  // Others.
  static const _homeRoute = "/home";
  static const _welcomeRoute = "/";
  static const _loginRoute = "/auth/login";
  static const _registerRoute = "/auth/register";
  static const _settingsRoute = "/settings";

  /// This is used to retrieve the route to the home page.
  static String getHomeRoute([String page = "dashboard"]) => "$_homeRoute?page=${Uri.encodeQueryComponent(page)}";

  /// The route to the welcome screen.
  static String getWelcomeRoute() => _welcomeRoute;

  /// The route to the login activity. When a user is already logged into the
  /// said environment, it would fetch the user's information kind of.
  static String getLoginRoute() => _loginRoute;

  /// The route to the login activity. When a user is already logged into the
  /// said environment, it would fetch the user's information kind of.
  static String getRegisterRoute() => _registerRoute;

  /// The route used to direct the user to the settings screen so this user can
  /// do any configurations he or she feels are necessary.
  static String getSettingsRoute([String page = "general", String origin = "home"]) =>
      "$_settingsRoute?origin=$origin&page=$page";

  /// Ths is is a helper function used to retrieve the initial route that should
  /// be viewed when the application is opened up.
  static String getInitialRoute([Object? data]) {
    return getWelcomeRoute();
  }

  /// A helper function used to match every single route to its true location
  /// while we are also keeping in mind that this is probably mapping to the
  /// update screen when this version of the app is stale.
  static Widget routeHandler(BuildContext context, String path) {
    //? Now, it is time to switch things up.
    switch (path) {
      case _welcomeRoute:
        return const WelcomeScreen();

      case _loginRoute:
        return const LoginScreen();

      case _registerRoute:
        return const RegisterScreen();

      case _settingsRoute:
        return const SettingsScreen();

      case _homeRoute:
        return const HomeScreen();

      default:
        return const NotFoundScreen();
    }
  }
}
