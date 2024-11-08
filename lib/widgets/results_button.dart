import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

class ResultsButton extends StatelessWidget {
  final bool selected;
  final String name;
  final int resultCount;
  final VoidCallback onClicked;

  const ResultsButton({
    super.key,
    required this.selected,
    required this.name,
    required this.resultCount,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedStyledTextButton(
      text: "$name ($resultCount)",
      horizontalPadding: Dimensions.paddingSizeSmall,
      verticalPadding: Dimensions.paddingSizeExtraSmall,
      backgroundColor: selected ? ThemeColors.colorErrorSubtle : ThemeColors.textfieldFillNormal,
      textColor: selected ? ThemeColors.primaryColor : ThemeColors.colorTextGray,
      borderColor: selected ? ThemeColors.primaryColor : ThemeColors.colorTextGray,
      onClick: onClicked,
      fontSize: Dimensions.fontSizeSmaller,
      svg: selected ? AppIcons.selectedButton : null,
      iconSize: Dimensions.fontSizeOverSmall,
    );
  }
}
