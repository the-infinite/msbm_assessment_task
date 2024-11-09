import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/models/auth.dart';
import 'package:msbm_assessment_test/repositories/auth.dart';

class AuthController extends StateController<UserModel, AuthRepository> {
  /// A helper utility used to check whether or not any user is currently logged
  /// in.
  bool get isLoggedIn => currentState != null;

  // Construct.
  AuthController({required super.repo}) {
    initialize(repository.cachedUser);
  }

  Future<bool> saveUser(UserModel data) async {
    invalidate(data);
    return repository.saveUser(data);
  }
}
