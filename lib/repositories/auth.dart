import 'dart:convert';

import 'package:msbm_assessment_test/core/data/repo.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/models/auth.dart';

class AuthRepository extends DataRepository {
  /// Repository utility used to save a given user's information to this device.
  /// Useful perhaps to know WHO is currently using this device.
  Future<bool> saveUser(UserModel data) {
    return localStorage.setString(AppConstants.session, jsonEncode(data.toSavedState()));
  }

  /// The user information for the user that has been saved to this device.
  UserModel? get cachedUser {
    final saved = localStorage.getString(AppConstants.session);

    //? If this is undefined, return this as is.
    if (saved == null) return null;

    //? Since we found something...
    return UserModel.fromState(jsonDecode(saved));
  }
}
