import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/images.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

class UnknownErrorScreen extends StatelessWidget {
  final dynamic error;
  final StackTrace? stackTrace;
  final Widget? child;

  // Construct.
  const UnknownErrorScreen({
    super.key,
    required this.error,
    required this.stackTrace,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //? The error icon
          SvgPicture.asset(
            Images.error,
            height: 100,
          ),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Next, the subtitle of this dialog.
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: fontSemiBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
            ),
          ),

          //? When the child of this widget is not null...
          if (child != null) ...[
            //? First, the space here.
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),

            //? Second, the child itself.
            child!,
          ],
        ],
      ),
    );
  }
}
