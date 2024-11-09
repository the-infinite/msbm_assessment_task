import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/controllers/auth.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/modals.dart';
import 'package:msbm_assessment_test/helper/regions.dart';
import 'package:msbm_assessment_test/helper/route.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/helper/text.dart';
import 'package:msbm_assessment_test/models/auth.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';
import 'package:msbm_assessment_test/widgets/themed/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstnameController = TextEditingController();
  final _firstnameStateNotifier = ValueNotifier(TextFieldState.normal);
  final _firstnameErrorController = ValueNotifier("");
  final _lastnameController = TextEditingController();
  final _lastnameStateNotifier = ValueNotifier(TextFieldState.normal);
  final _lastnameErrorController = ValueNotifier("");
  final _emailController = TextEditingController();
  final _emailStateNotifier = ValueNotifier(TextFieldState.normal);
  final _emailErrorController = ValueNotifier("");
  final _phoneController = PhoneTextFieldController();
  final _phoneStateNotifier = ValueNotifier(TextFieldState.normal);
  final _phoneErrorController = ValueNotifier("");
  final _passwordController = TextEditingController();
  final _passwordStateNotifier = ValueNotifier(TextFieldState.normal);
  final _passwordErrorController = ValueNotifier("");
  final _confirmController = TextEditingController();
  final _confirmStateNotifier = ValueNotifier(TextFieldState.normal);
  final _confirmErrorController = ValueNotifier("");
  final _referralController = TextEditingController();
  final _referralStateNotifier = ValueNotifier(TextFieldState.normal);
  final _referralErrorController = ValueNotifier("");
  final _loadingController = ValueNotifier<bool>(false);
  final _countryController = ValueNotifier<Country?>(null);

  void _registerUser() async {
    final firstname = _firstnameController.text.trim();
    final lastname = _lastnameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.phoneNumber;
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmController.text.trim();
    final referrer = _referralController.text.trim();

    //? This is what we do first.
    _firstnameStateNotifier.value = TextFieldState.normal;
    _lastnameStateNotifier.value = TextFieldState.normal;
    _emailStateNotifier.value = TextFieldState.normal;
    _phoneStateNotifier.value = TextFieldState.normal;
    _passwordStateNotifier.value = TextFieldState.normal;
    _confirmStateNotifier.value = TextFieldState.normal;
    _referralStateNotifier.value = TextFieldState.normal;

    // If there is no name
    if (firstname.isEmpty) {
      _firstnameStateNotifier.value = TextFieldState.error;
      _firstnameErrorController.value = "Your firstname must be specified.";
      return;
    }

    // If there is no name
    if (lastname.isEmpty) {
      _lastnameStateNotifier.value = TextFieldState.error;
      _lastnameErrorController.value = "Your lastname must be specified.";
      return;
    }

    // If there is no name
    if (!TextHelper.isEmail(email)) {
      _emailStateNotifier.value = TextFieldState.error;
      _emailErrorController.value = "A valid email address is required.";
      return;
    }

    // If this is not a valid phone number...
    if (phone.length < 10) {
      _phoneStateNotifier.value = TextFieldState.error;
      _phoneErrorController.value = "This is not a valid phone number";
      return;
    }

    // If this is not a password.
    if (password.isEmpty) {
      _passwordStateNotifier.value = TextFieldState.error;
      _passwordErrorController.value = "Password cannot be blank.";
      return;
    }

    // If this is not a password.
    if (confirmPassword != password) {
      _confirmStateNotifier.value = TextFieldState.error;
      _confirmErrorController.value = "These two passwords do not match.";
      return;
    }

    _firstnameStateNotifier.value = TextFieldState.normal;
    _lastnameStateNotifier.value = TextFieldState.normal;
    _emailStateNotifier.value = TextFieldState.normal;
    _phoneStateNotifier.value = TextFieldState.normal;
    _passwordStateNotifier.value = TextFieldState.normal;
    _confirmStateNotifier.value = TextFieldState.normal;
    _referralStateNotifier.value = TextFieldState.normal;

    // Now, it's loading.
    _loadingController.value = true;

    // Then this is fine too.
    final auth = AppRegistry.find<AuthController>();

    // This is fine.
    final response = await auth.saveUser(
      UserModel(
        firstname: firstname,
        lastname: lastname,
        phone: phone,
        email: email,
        password: password,
        referralCode: referrer,
      ),
    );

    // This is fine.
    _loadingController.value = false;

    // This is fair enough.
    if (!response) {
      ModalHelper.showSnackBar("Unable to add your profile to this device at this point in time");
      return;
    }

    // After everything, you can now redirect to the home screen.
    AppRegistry.nav.pushNamedAndRemoveUntil(RouteHelper.getHomeRoute(), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Build and return this widget.
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: size.height,
                color: ThemeColors.primaryColor,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                  top: Dimensions.paddingSize5XL,
                  left: Dimensions.paddingSize5XL,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? Title text.
                    Text(
                      "Save user profile",
                      textAlign: TextAlign.left,
                      style: fontSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSize5XL,
                      ),
                    ),

                    //? Subtitle text.
                    Text(
                      "Please provide all of the requested information so that we can save your user information in the app. Without doing so, you would not be able to gain access to the main activity. You only need to do this once however.",
                      textAlign: TextAlign.left,
                      style: fontRegular.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSize1XL,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // For the login form.
            Expanded(
              flex: 1,
              child: Container(
                height: size.height,
                color: Colors.white,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Now we get to the next part.
                      StyledTextField(
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        labelText: "Firstname",
                        controller: _firstnameController,
                        stateNotifier: _firstnameStateNotifier,
                        helperNotifier: _firstnameErrorController,
                      ),

                      // Some more space
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Now we get to the next part.
                      StyledTextField(
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        labelText: "Lastname",
                        controller: _lastnameController,
                        stateNotifier: _lastnameStateNotifier,
                        helperNotifier: _lastnameErrorController,
                      ),

                      // Some more space
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Now we get to the next part.
                      StyledTextField(
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        labelText: "Email address",
                        controller: _emailController,
                        stateNotifier: _emailStateNotifier,
                        helperNotifier: _emailErrorController,
                      ),

                      // Space between here and the password text controller.
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // So we've passed that section.
                      StyledPhoneTextField(
                        controller: _phoneController,
                        inputAction: TextInputAction.next,
                        countryController: _countryController,
                        countries: AppConstants.servedRegions,
                        stateNotifier: _phoneStateNotifier,
                        helperNotifier: _phoneErrorController,
                      ),

                      // Space between here and the password text controller.
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Now we get to the next part.
                      StyledPasswordTextField(
                        controller: _passwordController,
                        inputAction: TextInputAction.next,
                        stateNotifier: _passwordStateNotifier,
                        helperNotifier: _passwordErrorController,
                      ),

                      // Space between here and the password text controller.
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Now we get to the next part.
                      StyledPasswordTextField(
                        labelText: "Confirm password",
                        controller: _confirmController,
                        inputAction: TextInputAction.next,
                        stateNotifier: _confirmStateNotifier,
                        helperNotifier: _confirmErrorController,
                      ),

                      // Some more space
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Now we get to the next part.
                      StyledTextField(
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.done,
                        labelText: "Referral Code",
                        controller: _referralController,
                        stateNotifier: _referralStateNotifier,
                        helperNotifier: _referralErrorController,
                      ),

                      // Just some small space
                      const SizedBox(height: Dimensions.paddingSize2XL),

                      //? Next the button.
                      StyledTextButton(
                        text: "Save user information",
                        onClick: _registerUser,
                        endSvg: AppIcons.environmentTest,
                        colorSvg: true,
                        backgroundColor: ThemeColors.primaryColor,
                        loadingController: _loadingController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
