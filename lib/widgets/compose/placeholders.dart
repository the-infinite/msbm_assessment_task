import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A utility component used to construct placeholders for [Text] widgets.
class PlaceholderTextWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets margin;

  const PlaceholderTextWidget({
    super.key,
    required this.width,
    this.height = Dimensions.fontSizeDefault,
    this.margin = EdgeInsets.zero,
    this.borderRadius = Dimensions.radiusDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: ThemeColors.colorDisabledGray,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A utility component used to construct placeholders for [CircleAvatar] while
/// still waiting for the resource to be available.
class PlaceholderCircleAvatar extends StatelessWidget {
  final double height;
  final double width;

  const PlaceholderCircleAvatar({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: CircleAvatar(
        backgroundColor: ThemeColors.colorDisabledGray,
        radius: (height + width) / 4,
        child: SizedBox(
          height: height,
          width: width,
        ),
      ),
    );
  }
}

/// A utility component used to construct placeholders for images inside any
/// placeholder component inside our app. This is used in place of an [Image] or
/// a [SvgPicture] type.
class PlaceholderImage extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const PlaceholderImage({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = Dimensions.radiusDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ThemeColors.colorDisabledGray,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
