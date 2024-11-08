import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class StyledToolbar extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  final Widget actions;
  final bool showBack;

  //? This is fair enough.
  const StyledToolbar({
    super.key,
    required this.title,
    this.onPressed,
    this.icon = Icons.chevron_left,
    this.actions = const SizedBox(),
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //? First for the back-action button.
        if (showBack)
          StyledIconButton(
            onClick: onPressed ??
                () {
                  AppRegistry.nav.maybePop();
                },
            svg: AppIcons.navBack,
            backgroundColor: ThemeColors.textfieldFillNormal,
            iconColor: Colors.black,
            text: "esc",
            iconSize: 30,
            verticalPadding: 10,
            horizontalPadding: Dimensions.paddingSizeDefault,
          ),

        // Some space.
        const SizedBox(width: Dimensions.paddingSizeDefault),

        // Let this take max space.
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: fontSemiBold.copyWith(
              color: Colors.black,
              fontSize: Dimensions.fontSizeLarge,
            ),
          ),
        ),

        //? Next for the additional actions (as the case may be).
        actions,
      ],
    );
  }
}
