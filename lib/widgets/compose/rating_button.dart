import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class StyledButtonWithIcon extends StatelessWidget {
  final String name;
  final int index;
  final bool selected;
  final bool endGravity;
  final VoidCallback onClicked;
  final String selectedImage;
  final String image;

  const StyledButtonWithIcon({
    super.key,
    required this.index,
    required this.selected,
    required this.name,
    required this.onClicked,
    required this.selectedImage,
    required this.image,
    this.endGravity = true,
  });

  @override
  Widget build(BuildContext context) {
    final used = selected ? selectedImage : image;
    return OutlinedStyledTextButton(
      text: name,
      horizontalPadding: Dimensions.paddingSizeSmall,
      verticalPadding: Dimensions.paddingSizeExtraSmall,
      backgroundColor: selected ? ThemeColors.colorErrorSubtle : ThemeColors.textfieldFillNormal,
      textColor: selected ? ThemeColors.primaryColor : ThemeColors.colorTextGray,
      borderColor: selected ? ThemeColors.primaryColor : ThemeColors.colorTextGray,
      onClick: onClicked,
      fontSize: Dimensions.fontSizeSmaller,
      endSvg: endGravity ? used : null,
      svg: endGravity ? null : used,
    );
  }
}
