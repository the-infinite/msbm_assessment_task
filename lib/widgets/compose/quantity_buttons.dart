import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';

enum QuantityShiftButtonType {
  small,
  medium,
  large,
}

class QuantityShiftButtons extends StatelessWidget {
  final Color buttonColor;
  final Color borderColor;
  final Color textColor;
  final Color deleteColor;
  final Color deleteBorderColor;
  final double iconSize;
  final ButtonType buttonShape;
  final double quantityTextSize;
  final ValueNotifier<int> controller;
  final QuantityShiftButtonType buttonType;
  final void Function(int quantity)? onQuantityChanged;
  final void Function()? onUnitAdded;
  final void Function()? onUnitRemoved;

  /// Construct.
  const QuantityShiftButtons({
    super.key,
    required this.controller,
    this.buttonColor = ThemeColors.colorErrorSubtle,
    this.borderColor = ThemeColors.primaryColor,
    this.deleteColor = ThemeColors.colorSurfaceSubtle,
    this.deleteBorderColor = ThemeColors.colorDisabledGray,
    this.textColor = Colors.black,
    this.iconSize = Dimensions.fontSizeExtraLarge,
    this.quantityTextSize = Dimensions.fontSizeDefault,
    this.buttonType = QuantityShiftButtonType.small,
    this.buttonShape = ButtonType.roundedRectangle,
    this.onQuantityChanged,
    this.onUnitAdded,
    this.onUnitRemoved,
  });

  @override
  Widget build(BuildContext context) {
    // For the vertical padding.
    final verticalPadding = buttonType == QuantityShiftButtonType.small
        ? Dimensions.paddingSizeExtremelySmall
        : buttonType == QuantityShiftButtonType.medium
            ? Dimensions.paddingSizeExtraSmall
            : Dimensions.paddingSizeSomewhatSmall;

    // For the horizontal padding.
    final horizontalPadding = buttonType == QuantityShiftButtonType.small
        ? Dimensions.paddingSizeExtremelySmall
        : buttonType == QuantityShiftButtonType.medium
            ? Dimensions.paddingSizeExtraSmall
            : Dimensions.paddingSizeSomewhatSmall;

    // Return this one.
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, quantity, _) {
        /// Return this small row of oversimplified BS.
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// This is fair.
            OutlinedStyledIconButton(
              iconSize: iconSize,
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
              type: buttonShape,
              svg: quantity == 0
                  ? AppIcons.banned // Banned...
                  : quantity == 1
                      ? AppIcons.cancel // Delete...
                      : AppIcons.minus, // Remove.
              backgroundColor: quantity < 2 ? deleteColor : buttonColor,
              borderColor: quantity < 2 ? deleteBorderColor : borderColor,
              onClick: () {
                //? If this is in the clear...
                if (quantity < 1) {
                  return;
                }

                // Since we can move forward with life.
                onUnitRemoved?.call();
                onQuantityChanged?.call(quantity - 1);
                controller.value -= 1;
              },
            ),

            // Space.
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            // Now, for the quantity.
            Text(
              "$quantity",
              style: fontRegular.copyWith(
                fontSize: quantityTextSize,
                color: textColor,
              ),
            ),

            // Some more space.
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            /// This is fair.
            StyledIconButton(
              iconSize: iconSize,
              type: buttonShape,
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
              svg: AppIcons.plus,
              backgroundColor: buttonColor,
              borderColor: borderColor,
              onClick: () {
                onUnitAdded?.call();
                onQuantityChanged?.call(quantity + 1);
                controller.value += 1;
              },
            ),
          ],
        );
      },
    );
  }
}
