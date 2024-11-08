import 'dart:async';

import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class ChooseOptionDialogWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String positiveText;
  final String negativeText;
  final FutureOr<bool> Function() onConfirm;
  final FutureOr<void> Function() onDeny;

  const ChooseOptionDialogWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onConfirm,
    required this.onDeny,
    this.positiveText = "Yes",
    this.negativeText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    final acceptController = ValueNotifier(false);

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

        // Next, the subtitle of this dialog.
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: fontSemiBold.copyWith(
            fontSize: Dimensions.fontSizeOverLarge,
          ),
        ),

        // Next, infinite space.
        const SizedBox(height: Dimensions.paddingSize1XL),

        // Finally, the buttons in question.
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // For the negative button.
            Expanded(
              child: StyledTextButton(
                text: negativeText,
                backgroundColor: ThemeColors.textfieldFillNormal,
                textColor: ThemeColors.primaryColor,
                onClick: onDeny,
              ),
            ),

            // Some space.
            const SizedBox(width: Dimensions.paddingSizeDefault),

            // For the positive button.
            Expanded(
              child: StyledTextButton(
                text: positiveText,
                loadingController: acceptController,
                onClick: () async {
                  acceptController.value = true;

                  final result = await onConfirm();

                  // Disable this flag then.
                  acceptController.value = false;

                  // Then we can leave.
                  if (result) AppRegistry.nav.pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
