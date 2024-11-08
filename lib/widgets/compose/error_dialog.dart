import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/core/widget/boundary.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/images.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonClicked;

  const ErrorDialogWidget({
    super.key,
    required this.message,
    required this.title,
    this.buttonText,
    this.onButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    // You can close this now.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // First, the title of the country code picker.
        Text(
          title,
          textAlign: TextAlign.center,
          style: fontSemiBold.copyWith(
            fontSize: Dimensions.fontSizeOverLarge,
          ),
        ),

        // Next, some negligible space.
        const SizedBox(height: Dimensions.paddingSizeDefault),

        // Then a divider.
        const Divider(color: ThemeColors.colorTextGray, thickness: 1, height: 0),

        // Next, some negligible space.
        const SizedBox(height: Dimensions.paddingSizeDefault),

        //? The error icon
        SvgPicture.asset(
          Images.error,
          height: 100,
        ),

        // Next, some negligible space.
        const SizedBox(height: Dimensions.paddingSizeDefault),

        // Next, the subtitle of this dialog.
        Text(
          message,
          textAlign: TextAlign.center,
          style: fontSemiBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
          ),
        ),

        // Next, some negligible space.
        if (buttonText != null)
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),

        if (buttonText != null)
          StyledTextButton(
            text: buttonText!,
            onClick: onButtonClicked,
          ),
      ],
    );
  }
}

class SuccessDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryButtonClicked;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonClicked;
  final VoidCallback? onDismiss;

  const SuccessDialogWidget({
    super.key,
    required this.message,
    required this.title,
    this.primaryButtonText,
    this.onPrimaryButtonClicked,
    this.secondaryButtonText,
    this.onSecondaryButtonClicked,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // You can close this now.
    return InterceptorBoundary(
      onPopInvoked: () {
        onDismiss?.call();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // The title text here.
          Text(
            title,
            textAlign: TextAlign.center,
            style: fontSemiBold.copyWith(
              fontSize: Dimensions.fontSizeOverLarge,
            ),
          ),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Then a divider.
          const Divider(color: ThemeColors.colorTextGray, thickness: 1, height: 0),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          //? The error icon
          SvgPicture.asset(
            Images.check,
            height: 100,
          ),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Next, the subtitle of this dialog.
          Text(
            message,
            textAlign: TextAlign.center,
            style: fontSemiBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
            ),
          ),

          // Next, some negligible space if this is in fact something with
          // any usable buttons.
          if (primaryButtonText != null || secondaryButtonText != null)
            const SizedBox(height: Dimensions.paddingSizeDefault),

          // If one of these buttons is enabled...
          if (primaryButtonText != null || secondaryButtonText != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // For the negative button.
                if (secondaryButtonText != null)
                  Expanded(
                    child: StyledTextButton(
                      text: secondaryButtonText!,
                      backgroundColor: ThemeColors.textfieldFillNormal,
                      textColor: ThemeColors.primaryColor,
                      onClick: onSecondaryButtonClicked,
                    ),
                  ),

                // Some space.
                if (secondaryButtonText != null && primaryButtonText != null)
                  const SizedBox(
                    width: Dimensions.paddingSizeDefault,
                  ),

                // For the positive button.
                if (primaryButtonText != null)
                  Expanded(
                    child: StyledTextButton(
                      text: primaryButtonText!,
                      onClick: onPrimaryButtonClicked,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
