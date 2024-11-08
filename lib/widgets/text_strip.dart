import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';

class TextStrip extends StatelessWidget {
  final Color? backgroundColor;
  final String? text;
  final Color? textColor;

  const TextStrip(
    this.text, {
    super.key,
    this.backgroundColor = Colors.white,
    this.textColor = ThemeColors.colorTextGray,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Divider(
          color: textColor,
        ),

        //? If this is not empty...
        if (text != null && text!.isNotEmpty)
          Container(
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text!,
              style: TextStyle(
                backgroundColor: backgroundColor,
                color: textColor,
              ),
            ),
          )
      ],
    );
  }
}
