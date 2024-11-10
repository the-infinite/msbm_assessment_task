import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/controllers/auth.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/screens/auth/register.dart';
import 'package:msbm_assessment_test/screens/entry.dart';
import 'package:msbm_assessment_test/screens/errors/not_found.dart';
import 'package:msbm_assessment_test/screens/welcome.dart';

class RouteHelper {
  // Construct.
  RouteHelper._();

  // Others.
  static const _homeRoute = "/home";
  static const _welcomeRoute = "/";
  static const _registerRoute = "/auth/register";

  /// This is used to retrieve the route to the home page.
  static String getHomeRoute([String page = "dashboard"]) => "$_homeRoute?page=${Uri.encodeQueryComponent(page)}";

  /// The route to the welcome screen.
  static String getWelcomeRoute() => _welcomeRoute;

  /// The route to the login activity. When a user is already logged into the
  /// said environment, it would fetch the user's information kind of.
  static String getRegisterRoute() => _registerRoute;

  /// Ths is is a helper function used to retrieve the initial route that should
  /// be viewed when the application is opened up.
  static String getInitialRoute([Object? data]) {
    //? Since there is a user logged in, send them to the home route.
    if (AppRegistry.find<AuthController>().isLoggedIn) return getHomeRoute();

    //? Since there is no user logged in, send them to the welcoming route.
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

      case _registerRoute:
        return const RegisterScreen();

      case _homeRoute:
        return const HomeScreen();

      default:
        return const NotFoundScreen();
    }
  }
}
