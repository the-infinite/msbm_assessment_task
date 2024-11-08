import 'package:msbm_assessment_test/core/data/repo.dart';
import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/data/theme.dart';

class ThemeController extends StateController<ThemeState, DataRepository> {
  /// Is the app currently in dark theme?
  bool get isDarkTheme => currentState?.isDark ?? false;

  /// This is fine.
  ThemeController(bool isDark, {super.repo = DataRepository.empty}) {
    // We initialize this controller using the theme state present here.
    initialize(ThemeState(isDark: isDark));
  }
}
