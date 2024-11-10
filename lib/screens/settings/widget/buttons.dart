import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/themed/options.dart';

class EmulateWebSocketButton extends StatelessWidget {
  final ValueNotifier<bool> controller;

  const EmulateWebSocketButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.value = !controller.value;
      },
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, isSelected, _) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: ThemeColors.textfieldFillNormal,
              border: Border.all(color: isSelected ? ThemeColors.textfieldLabelColor : ThemeColors.colorDisabledGray),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First, the label that goes there.
                Text(
                  "Emulate websocket",
                  style: fontRegular.copyWith(
                    color: ThemeColors.colorTextGray,
                  ),
                ),

                // Next some space.
                const Spacer(),

                //? Finally the checkbox.
                StyledRoundCheckbox(
                  changeNotifier: controller,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
