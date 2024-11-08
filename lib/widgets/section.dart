import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

class ActionDetailSection extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const ActionDetailSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeDefault,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Dimensions.radiusDefault,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First, show this one.
          if (icon.isNotEmpty)
            SvgPicture.asset(
              icon,
              height: Dimensions.fontSize2XL,
              color: ThemeColors.primaryColor,
            ),

          // Next some tiny space.
          if (icon.isNotEmpty)
            const SizedBox(
              width: Dimensions.paddingSizeSmall,
            ),

          // Second, the
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Then the title text.
                Text(
                  title,
                  style: fontSemiBold.copyWith(
                    color: ThemeColors.colorNeutralDark,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),

                // Next some tiny space.
                if (description.isNotEmpty)
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                  ),

                // Then this is fine too.
                if (description.isNotEmpty)
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: fontRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmaller,
                      color: ThemeColors.colorTextGray,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
