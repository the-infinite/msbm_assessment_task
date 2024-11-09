import 'package:msbm_assessment_test/core/state/state.dart';

class UserModel extends ObjectState {
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final String password;
  final String? referralCode;

  // This is fine.
  UserModel({
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.password,
    required this.referralCode,
  });

  factory UserModel.fromState(SavedStateData data) {
    return UserModel(
      email: data["email"],
      firstname: data["firstname"],
      lastname: data["lastname"],
      phone: data["phone"],
      password: data["password"],
      referralCode: data["referralCode"],
    );
  }

  @override
  SavedStateData toSavedState() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      'password': password,
      'referral_code': referralCode,
    };
  }
}
