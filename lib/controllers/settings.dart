import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/helper/modals.dart';
import 'package:msbm_assessment_test/models/settings.dart';
import 'package:msbm_assessment_test/repositories/settings.dart';

class SettingsController extends StateController<SettingsModel, SettingsRepository> {
  bool _defaultCreated = false;

  // Construct.
  SettingsController({required super.repo}) {
    initialize(repository.cachedSettings);
  }

  /// A controller utility function used to create the default settings file
  /// according to the required schema ONLY when it has not been created.
  void createDefaultSettings() async {
    //? If this has been done, leave.
    if (_defaultCreated) return;

    //? This is now officially created.
    _defaultCreated = true;

    //? If there are settings already created and set up.
    if (repository.cachedSettings != null) {
      AppRegistry.debugLog(
        "Skipping default settings creation because an existing settings configuration is found",
        "Helpers.Settings",
      );
      return;
    }

    //? This is fine.
    final defaults = SettingsModel(
      websocketUrl: null,
      version: 1,
      emulateWebsocket: true,
    );

    // This is fine.
    final result = await repository.cacheSettings(defaults);

    //? If this failed..
    if (!result) ModalHelper.showSnackBar("Failed to create default settings");

    //? This is fine.
    invalidate(defaults);
  }

  /// A controller utility function used to update the settings that are
  /// persisted in the settings file.
  void cacheSettings(SettingsModel settings) async {
    final result = await repository.cacheSettings(settings);

    //? If this failed..
    if (!result) {
      ModalHelper.showSnackBar("Failed to update application settings");
    }

    //? Since it was successful.
    else {
      ModalHelper.showSnackBar("Settings updated successfully", false);
    }

    //? This is fine.
    invalidate(settings);
  }
}
