import 'package:flutter/material.dart';

class ImageWithOverlay extends StatelessWidget {
  final Color overlayColor;
  final DecorationImage image;
  final Widget child;
  final double yGradient;

  // This is fine.
  const ImageWithOverlay({
    super.key,
    required this.overlayColor,
    required this.image,
    required this.child,
    this.yGradient = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //? This is fine.
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: image,
          ),
        ),

        //? This is fine.
        Container(
          decoration: BoxDecoration(
            color: overlayColor,
            gradient: LinearGradient(
              begin: FractionalOffset(0.5, yGradient),
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.transparent,
                overlayColor,
              ],
              stops: const [
                0.0,
                1.0,
              ],
            ),
          ),
        ),

        // Now for the widget itself
        child,
      ],
    );
  }
}
