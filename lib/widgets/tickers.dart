import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';
import 'package:msbm_assessment_test/widgets/themed/textfield.dart';

class InputChipWidget extends StatelessWidget {
  final ValueNotifier<String> controller;
  final TextEditingController textController;

  // Construct.
  const InputChipWidget({
    super.key,
    required this.controller,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: ThemeColors.textfieldFillNormal,
        border: Border.all(
          color: ThemeColors.colorTextGray,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //* For the first row, this is where we put the components required to
          //* add new chips to the list.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //? First, the text field that is used.
              Expanded(
                child: StyledTextField(
                  controller: textController,
                  labelText: "",
                  borderColor: Colors.transparent,
                ),
              ),

              // Some space.
              const SizedBox(width: Dimensions.paddingSizeDefault),

              //? Finally, the button that is used to push the value forward.
              StyledTextButton(
                text: "Add",
                svg: AppIcons.plus,
                colorSvg: true,
                onClick: () {
                  final text = textController.text.trim();
                  final raw = controller.value.split(",").where((element) => element.isNotEmpty).toList();

                  //? If this is empty...
                  if (text.isEmpty) return;

                  //* Add this to our target...
                  raw.add(text);

                  //* Modify this one.
                  controller.value = raw.join(",");
                  textController.clear();
                },
              ),
            ],
          ),

          //* For the second row, this is where we put the input chips that have
          //* been generated.
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, values, _) {
              //? This is fine.
              var choices = values.split(",").where((element) => element.isNotEmpty).toList();

              //? This is fine.
              return Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: Dimensions.paddingSizeExtraSmall,
                runSpacing: Dimensions.paddingSizeExtraSmall,
                children: List.generate(
                  choices.length,
                  (index) => choices[index].isEmpty
                      ? const SizedBox()
                      : _InputChip(
                          index: index,
                          value: choices[index],
                          controller: controller,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InputChip extends StatelessWidget {
  final int index;
  final String value;
  final ValueNotifier<String> controller;

  // Construct.
  const _InputChip({
    required this.index,
    required this.value,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall,
          horizontal: Dimensions.paddingSizeSmaller,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
          border: Border.all(color: ThemeColors.primaryColor),
          color: ThemeColors.colorPrimarySubtle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //? First, the name of this country.
            Text(
              value,
              style: fontRegular.copyWith(
                fontSize: Dimensions.fontSizeEvenSmaller,
                color: ThemeColors.primaryColor,
              ),
            ),

            //? Next, the delete button.
            StyledIconButton(
              svg: AppIcons.cancel,
              colorSvg: true,
              iconColor: ThemeColors.primaryColor,
              verticalPadding: Dimensions.paddingSizeExtraSmall,
              horizontalPadding: Dimensions.paddingSizeExtraSmall,
              backgroundColor: Colors.transparent,
              onClick: () {
                final raw = controller.value.split(",").where((element) => element.isNotEmpty).toList();

                //? If this is empty...
                if (index >= raw.length) return;

                //* Add this to our target...
                raw.removeAt(index);

                //* Modify this one.
                controller.value = raw.join(",");
              },
            ),
          ],
        ),
      ),
    );
  }
}
