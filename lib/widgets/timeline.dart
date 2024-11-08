import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

class TimelineEntry<T> {
  final T value;
  final String title;
  final dynamic data;

  const TimelineEntry(this.value, this.title, this.data);
}

class SimpleTimeline<T> extends StatelessWidget {
  final T value;
  final List<TimelineEntry<T>> children;
  final double fontSize;
  final Color activeColor;
  final Color inactiveColor;
  final bool Function(T first, T value) comparator;
  final double width;

  // This is fine.
  const SimpleTimeline({
    super.key,
    required this.value,
    required this.children,
    required this.comparator,
    required this.width,
    this.fontSize = Dimensions.fontSizeDefault,
    this.activeColor = ThemeColors.primaryColor,
    this.inactiveColor = ThemeColors.colorDisabledGray,
  });

  bool _isActive(int index) {
    return comparator(children[index].value, value);
  }

  @override
  Widget build(BuildContext context) {
    // We create the gap
    final gapWidth = (width / children.length - 1) - (fontSize / children.length + 1);

    // This is fine.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // This is fine.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children.map(
            (state) {
              return Container(
                height: fontSize,
                width: fontSize,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtremelySmall,
                ),
                child: Text(
                  state.title,
                  style: fontSemiBold.copyWith(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                ),
              );
            },
          ).toList(),
        ),

        // Some space in between.
        const SizedBox(height: Dimensions.paddingSizeSmall),

        // This is fine.
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              children.length,
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // First, the conditional container block.
                    if (index > 0)
                      SizedBox(
                        height: Dimensions.paddingSizeExtraSmall,
                        width: gapWidth,
                        child: Container(
                          height: Dimensions.paddingSizeExtraSmall,
                          color: _isActive(index) ? activeColor : inactiveColor,
                        ),
                      ),

                    // What gets built here anyways.
                    Container(
                      padding: const EdgeInsets.all(1.5),
                      height: fontSize,
                      width: fontSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isActive(index) ? activeColor : inactiveColor,
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
                      ),
                      child: CircleAvatar(
                        backgroundColor: _isActive(index) ? activeColor : inactiveColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
