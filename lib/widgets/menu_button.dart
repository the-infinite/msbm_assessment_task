import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class MenuButton extends StatelessWidget {
  final bool selected;
  final String name;
  final VoidCallback onClicked;

  const MenuButton({
    super.key,
    required this.selected,
    required this.name,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return StyledTextButton(
      text: name,
      horizontalPadding: Dimensions.paddingSizeSmall,
      verticalPadding: Dimensions.paddingSizeExtraSmall,
      backgroundColor: selected ? ThemeColors.colorBlueSubtle : ThemeColors.textfieldFillNormal,
      textColor: selected ? ThemeColors.primaryColor : ThemeColors.colorTextGray,
      onClick: onClicked,
      fontSize: Dimensions.fontSizeSmaller,
      svg: selected ? AppIcons.selectedButton : null,
      colorSvg: true,
      iconSize: Dimensions.fontSizeOverSmall,
    );
  }
}
