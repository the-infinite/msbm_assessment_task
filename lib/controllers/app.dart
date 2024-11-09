import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/models/app.dart';
import 'package:msbm_assessment_test/repositories/app.dart';

class AppController extends StateController<AppModel, AppRepository> {
  bool _isWindowShowing = true;

  AppController({required super.repo}) {
    initialize(null);
  }

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
}
