import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/models/settings.dart';
import 'package:msbm_assessment_test/repositories/settings.dart';

class SettingsController extends StateController<SettingsModel, SettingsRepository> {
  SettingsController({required super.repo}) {
    initialize(null);
  }
}
