import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

class AccordionWidget extends StatelessWidget {
  final bool initialState;
  final String title;
  final String description;

  const AccordionWidget({
    super.key,
    required this.title,
    required this.description,
    this.initialState = false,
  });

  @override
  Widget build(BuildContext context) {
    // Create the state controller.
    final stateController = ValueNotifier(initialState);

    // Return this widget.
    return ValueListenableBuilder(
      valueListenable: stateController,
      builder: (context, isOpen, _) {
        return InkWell(
          onTap: () {
            stateController.value = !stateController.value;
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: ThemeColors.colorDisabledGray),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //? First, the title and icon.
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //? First, the title.
                    Expanded(
                      child: Text(
                        title,
                        style: fontRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),

                    // We put some space here.
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    //? Second, the image.
                    SvgPicture.asset(
                      isOpen ? AppIcons.caretUp : AppIcons.caretDown,
                      height: Dimensions.fontSize2XL,
                      color: ThemeColors.primaryColor,
                    ),
                  ],
                ),

                // Followed by a little space.
                if (isOpen)
                  const SizedBox(
                    height: Dimensions.paddingSizeSomewhatSmall,
                  ),

                //? Second the divider.
                if (isOpen)
                  const Divider(
                    height: 0,
                    color: ThemeColors.colorDisabledGray,
                    thickness: 1,
                  ),

                // Followed by a little space.
                if (isOpen)
                  const SizedBox(
                    height: Dimensions.paddingSizeSomewhatSmall,
                  ),

                // If it is open...
                if (isOpen)
                  Text(
                    description,
                    style: fontRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
