import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';

class RatingsBar extends StatelessWidget {
  final double rating;
  final double iconSize;

  const RatingsBar({
    super.key,
    required this.rating,
    this.iconSize = Dimensions.fontSizeDefault,
  });

  @override
  Widget build(BuildContext context) {
    // Return this one.
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [0, 1, 2, 3, 4].map(
        (index) {
          final currentRating = rating - index;

          //? If this is a whole number.
          if (currentRating < 1 && currentRating > 0) {
            return SvgPicture.asset(
              AppIcons.ratingStarHalf,
              height: iconSize,
            );
          }

          //? If this is positive...
          if (currentRating > 0) {
            return SvgPicture.asset(
              AppIcons.ratingStarFull,
              height: iconSize,
            );
          }

          // Return an empty star.
          return SvgPicture.asset(
            AppIcons.ratingStar,
            height: iconSize,
          );
        },
      ).toList(),
    );
  }
}

class RatingController extends StatelessWidget {
  final ValueNotifier<double> controller;
  final double iconSize;

  const RatingController({
    super.key,
    required this.controller,
    this.iconSize = Dimensions.fontSize2XL,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, currentRating, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            5,
            (index) => _RatingButton(controller, index, iconSize),
          ),
        );
      },
    );
  }
}

class _RatingButton extends StatelessWidget {
  final ValueNotifier<double> controller;
  final int index;
  final double iconSize;

  const _RatingButton(
    this.controller,
    this.index,
    this.iconSize,
  );

  @override
  Widget build(BuildContext context) {
    final currentRating = controller.value - index;

    return InkWell(
      onTap: () {
        controller.value = index + 1;
      },
      child: (currentRating < 1 && currentRating > 0)
          ? SvgPicture.asset(
              AppIcons.ratingStarHalf,
              height: iconSize,
            )
          : (currentRating > 0)
              ? SvgPicture.asset(
                  AppIcons.ratingStarFull,
                  height: iconSize,
                )
              : SvgPicture.asset(
                  AppIcons.ratingStar,
                  height: iconSize,
                ),
    );
  }
}
