import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

class HygieneRatingNumberLine extends StatelessWidget {
  final int rating;
  final double fontSize;
  final Color activeColor;
  final Color inactiveColor;

  const HygieneRatingNumberLine({
    super.key,
    required this.rating,
    this.fontSize = Dimensions.fontSizeDefault,
    this.activeColor = ThemeColors.primaryColor,
    this.inactiveColor = ThemeColors.colorDisabledGray,
  });

  Color _sectionColor(int position) => rating >= position ? activeColor : inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // This is fine.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            5,
            (index) {
              return Container(
                height: fontSize + 6,
                width: fontSize + 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtremelySmall,
                ),
                child: Text(
                  "${index + 1}",
                  style: fontSemiBold.copyWith(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                ),
              );
            },
          ),
        ),

        // Some space in between.
        const SizedBox(height: Dimensions.paddingSizeSmall),

        // This is fine.
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // What gets built here anyways.
            Container(
              padding: const EdgeInsets.all(1.5),
              height: fontSize,
              width: fontSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _sectionColor(1),
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
              ),
              child: CircleAvatar(
                backgroundColor: _sectionColor(1),
              ),
            ),

            // For the second, hygiene rating.
            Expanded(
              child: Container(
                height: Dimensions.paddingSizeExtraSmall,
                color: _sectionColor(2),
              ),
            ),

            // What gets built here anyways.
            Container(
              padding: const EdgeInsets.all(1.5),
              height: fontSize,
              width: fontSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _sectionColor(2),
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
              ),
              child: CircleAvatar(
                backgroundColor: _sectionColor(2),
              ),
            ),

            // For the third hygiene rating.
            Expanded(
              child: Container(
                height: Dimensions.paddingSizeExtraSmall,
                color: _sectionColor(3),
              ),
            ),

            // What gets built here anyways.
            Container(
              padding: const EdgeInsets.all(1.5),
              height: fontSize,
              width: fontSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _sectionColor(3),
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
              ),
              child: CircleAvatar(
                backgroundColor: _sectionColor(3),
              ),
            ),

            // For the fourth hygiene rating.
            Expanded(
              child: Container(
                height: Dimensions.paddingSizeExtraSmall,
                color: _sectionColor(4),
              ),
            ),

            // What gets built here anyways.
            Container(
              padding: const EdgeInsets.all(1.5),
              height: fontSize,
              width: fontSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _sectionColor(4),
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
              ),
              child: CircleAvatar(
                backgroundColor: _sectionColor(4),
              ),
            ),

            // For the fifth hygiene rating.
            Expanded(
              child: Container(
                height: Dimensions.paddingSizeExtraSmall,
                color: _sectionColor(5),
              ),
            ),

            // What gets built here anyways.
            Container(
              padding: const EdgeInsets.all(1.5),
              height: fontSize,
              width: fontSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _sectionColor(5),
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
              ),
              child: CircleAvatar(
                backgroundColor: _sectionColor(5),
              ),
            ),
          ],
        )
      ],
    );
  }
}
