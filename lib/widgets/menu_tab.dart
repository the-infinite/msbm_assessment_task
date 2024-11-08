import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';

class MenuTabWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final VoidCallback onClick;
  final double fontSize;
  final Color activeColor;
  final Color inactiveColor;

  const MenuTabWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onClick,
    this.fontSize = Dimensions.fontSizeDefault,
    this.activeColor = ThemeColors.primaryColor,
    this.inactiveColor = ThemeColors.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //? First, the title.
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),

          // Done this again.
          const SizedBox(height: Dimensions.paddingSizeSmall),

          // Move forward again.
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  Dimensions.radiusLarge,
                ),
                topRight: Radius.circular(
                  Dimensions.radiusLarge,
                ),
              ),
            ),
            child: const SizedBox(
              height: Dimensions.paddingSizeExtraSmall,
            ),
          ),
        ],
      ),
    );
  }
}
