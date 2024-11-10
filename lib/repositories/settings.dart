import 'dart:convert';

import 'package:msbm_assessment_test/core/data/repo.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/models/settings.dart';

class SettingsRepository extends DataRepository {
  SettingsModel? get cachedSettings {
    final saved = localStorage.getString(AppConstants.settings);

    //? If this is undefined, return this as is.
    if (saved == null) return null;

    //? Since we found something...
    return SettingsModel.fromState(jsonDecode(saved));
  }

  Future<bool> cacheSettings(SettingsModel data) {
    return localStorage.setString(AppConstants.settings, jsonEncode(data.toSavedState()));
  }
}
