import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/screens/home/logic/navigation.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class NavigationDrawerButtonWidget extends StatelessWidget {
  final int value;
  final NavigationController controller;
  final String icon;
  final String title;

  // Construct.
  const NavigationDrawerButtonWidget({
    super.key,
    required this.value,
    required this.controller,
    required this.icon,
    required this.title,
  });

  /// Function used internally to select the
  void _selectChild() {
    controller.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, groupValue, _) {
        return Padding(
          padding: value == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: StyledTextButton(
            text: title,
            backgroundColor: groupValue == value ? Colors.white : Colors.white.withOpacity(0.1),
            svg: icon,
            textColor: groupValue == value ? ThemeColors.primaryColor : Colors.white,
            colorSvg: true,
            horizontalPadding: Dimensions.fontSizeDefault,
            spaceEvenly: null,
            onClick: groupValue == value ? null : _selectChild,
          ),
        );
      },
    );
  }
}
