import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/route.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  /// Go to the signup screen.
  void _toSignup() {
    AppRegistry.nav.pushNamed(RouteHelper.getRegisterRoute());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

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
                color: ThemeColors.primaryColorLight,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                  top: Dimensions.paddingSize5XL,
                  left: Dimensions.paddingSize5XL,
                ),
                child: Text(
                  "Oluwatobiloba\nJohnson",
                  textAlign: TextAlign.left,
                  style: fontSemiBold.copyWith(
                    color: ThemeColors.colorNeutralDark,
                    fontSize: 72,
                  ),
                ),
              ),
            ),

            // For the controller.
            Expanded(
              flex: 1,
              child: Container(
                height: size.height,
                color: Colors.white,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //? Title text.
                    Text(
                      "MSBM Assessment Task",
                      textAlign: TextAlign.left,
                      style: fontSemiBold.copyWith(
                        color: ThemeColors.colorNeutralDark,
                        fontSize: Dimensions.fontSize5XL,
                      ),
                    ),

                    // Just some small space
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    //? Subtitle text.
                    Text(
                      "You can proceed with the application after you save your user account for the first time. Instructions on how to use this app can be found in the main activity.",
                      textAlign: TextAlign.left,
                      style: fontRegular.copyWith(
                        color: ThemeColors.colorTextGray,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),

                    // Just some small space
                    const SizedBox(height: Dimensions.paddingSize2XL),

                    //? Now for the registration notice.
                    StyledTextButton(
                      text: "Proceed",
                      onClick: _toSignup,
                      endSvg: AppIcons.employee,
                      colorSvg: true,
                      backgroundColor: ThemeColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
