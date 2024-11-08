import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

class SectionTitleWidget extends StatelessWidget {
  final String name;
  final bool required;
  final Color textColor;
  final Color requiredColor;
  final double textSize;
  final double requiredSize;

  const SectionTitleWidget({
    super.key,
    required this.name,
    required this.required,
    this.textColor = Colors.black,
    this.requiredColor = ThemeColors.primaryColor,
    this.textSize = Dimensions.fontSizeDefault,
    this.requiredSize = Dimensions.fontSizeEvenSmaller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //? First, the title text.
        Text(
          name,
          style: fontSemiBold.copyWith(
            color: textColor,
            fontSize: textSize,
          ),
        ),

        //? Second, the required text.
        if (required)
          Text(
            "Required",
            style: fontRegular.copyWith(
              color: requiredColor,
              fontSize: requiredSize,
            ),
          ),
      ],
    );
  }
}
