import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int total;
  final int progress;
  final Color progressColor;
  final Color baseColor;
  final double height;

  const ProgressBar({
    super.key,
    required this.total,
    required this.progress,
    required this.progressColor,
    required this.baseColor,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final difference = total - progress;

    // Return this.
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1999999999),
        color: baseColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First, the actual progress.
          if (progress > 0)
            Flexible(
              flex: difference == 0 ? 1 : progress,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1999999999),
                  color: progressColor,
                ),
              ),
            ),

          // Next, the empty space.
          if (difference > 0)
            Flexible(
              flex: difference,
              child: const SizedBox(),
            ),
        ],
      ),
    );
  }
}
