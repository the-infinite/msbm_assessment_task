import 'package:msbm_assessment_test/controllers/theme.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/client.dart';
import 'package:msbm_assessment_test/core/widget/boundary.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A helper class that has the sole function of initializing the initial state
/// of the registry.
class RegistryHelper {
  RegistryHelper._();

  /// This is also fair enough.
  static Future<void> init() async {
    // First, get the shared preferences.
    final prefs = await SharedPreferences.getInstance();

    /// Second, the data data sources.
    AppRegistry.register(prefs);
    AppRegistry.register(AppClient());
    AppRegistry.register(InterceptorController());

    // Third, the controllers.
    AppRegistry.register(ThemeController(false));

    // Log this.
    AppRegistry.debugLog("Helpers.AppRegistry: Initialized successfully.");
  }
}
