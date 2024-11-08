import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/images.dart';
import 'package:msbm_assessment_test/widgets/cached_image.dart';

class AvatarImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  // This is fine.
  const AvatarImage({
    super.key,
    required this.image,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: ThemeColors.colorDisabledGray,
      radius: height / 2,
      child: image.isEmpty
          ? SvgPicture.asset(
              Images.avatarImage,
              height: height,
              width: width,
            )
          : ClipPath(
              clipper: const ShapeBorderClipper(shape: CircleBorder()),
              child: CachedNetworkImage(
                image,
                height: height,
                width: width,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
