import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

enum ButtonType {
  /// Circular buttons
  circular,

  /// Buttons shaped like squircles.
  squircle,

  /// Buttons shaped like pills or stadiums.
  pill,

  /// The rounded rectangle
  roundedRectangle,
}

/// For text buttons as they are rendered in the mobile app. Useful utility
/// function for drawing text buttons to the screen.
class StyledTextButton extends StatefulWidget {
  /// The text to show on top of this button.
  final String text;

  /// The shape of this button.
  final ButtonType type;

  /// What to do when the button is clicked.
  final void Function()? onClick;

  /// The progress state controller. When this is true, the button would show a
  /// progress spinner and when this is false, it would show its content.
  final ValueNotifier<bool>? loadingController;

  /// The  background color of this
  final Color? backgroundColor;

  /// The color of the border to use.
  final Color? borderColor;

  /// The size of the border.
  final double borderSize;

  /// The color of the text on this button.
  final Color textColor;

  /// The horizontal padding of the buttons.
  final double horizontalPadding;

  /// The horizontal padding of the buttons.
  final double verticalPadding;

  /// The icon at the start of this button.
  final IconData? startIcon;

  /// The icon at the end of this button.
  final IconData? endIcon;

  /// This is the path to the SVG icon that might need to be rendered inside
  /// this button.
  final String? svg;

  /// The size of the icons we are rendering.
  final double iconSize;

  /// The size of the icons we are rendering.
  final double fontSize;

  /// This is the SVG icon we put at the end.
  final String? endSvg;

  /// The family of fonts this comes from.
  final String fontFamily;

  /// Should we color the icon or not?
  final bool colorSvg;

  /// The constraints on this button.
  final BoxConstraints? constraints;

  /// Should the icon be spaced evenly or not?
  final bool? spaceEvenly;

  // This is fine.
  const StyledTextButton({
    super.key,
    required this.text,
    this.type = ButtonType.roundedRectangle,
    this.fontFamily = AppConstants.fontFamily,
    this.textColor = Colors.white,
    this.horizontalPadding = Dimensions.paddingSizeDefault,
    this.verticalPadding = Dimensions.paddingSizeDefault,
    this.fontSize = Dimensions.fontSizeDefault,
    this.borderSize = 1,
    this.iconSize = 20,
    this.colorSvg = false,
    this.spaceEvenly = false,
    this.constraints,
    this.loadingController,
    this.onClick,
    this.backgroundColor,
    this.borderColor,
    this.startIcon,
    this.endIcon,
    this.svg,
    this.endSvg,
  });

  @override
  State<StyledTextButton> createState() => _StyledTextButtonState();
}

class _StyledTextButtonState extends State<StyledTextButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: ThemeColors.primaryColor.withOpacity(0.1),
        onTap: widget.loadingController?.value == true ? null : widget.onClick,
        mouseCursor: SystemMouseCursors.click,
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: ContinuousRectangleBorder(
              borderRadius: widget.type == ButtonType.squircle ? BorderRadius.circular(40) : BorderRadius.zero,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding,
              horizontal: widget.horizontalPadding,
            ),
            constraints: widget.constraints,
            decoration: BoxDecoration(
              border: widget.borderColor != null
                  ? Border.all(
                      color: widget.borderColor!,
                      width: widget.borderSize,
                    )
                  : null,
              color: widget.backgroundColor ?? Theme.of(context).primaryColor,
              shape: BoxShape.rectangle,
              borderRadius: widget.type == ButtonType.roundedRectangle
                  ? BorderRadius.circular(Dimensions.radiusDefault)
                  : BorderRadius.circular(Dimensions.radiusInfinite),
            ),
            child: Row(
              mainAxisAlignment: widget.spaceEvenly == null
                  ? MainAxisAlignment.start
                  : widget.spaceEvenly!
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //? If there is a start icon added to this button.
                if (widget.startIcon != null && widget.svg == null)
                  Icon(
                    widget.startIcon,
                    color: widget.textColor,
                    size: widget.iconSize,
                  ),

                //? If there is a starting SVG defined.
                if (widget.svg != null)
                  SvgPicture.asset(
                    widget.svg!,
                    width: widget.iconSize,
                    color: widget.colorSvg ? widget.textColor : null,
                  )
                else if (widget.spaceEvenly == true && (widget.endSvg != null || widget.endIcon != null))
                  const SizedBox(),

                //? Space only when there is an icon at the start.
                if (widget.spaceEvenly != true &&
                    (widget.startIcon != null || widget.svg != null) &&
                    widget.text.isNotEmpty)
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                // For the title of the button.
                if (widget.loadingController != null)
                  ValueListenableBuilder(
                    valueListenable: widget.loadingController!,
                    builder: (context, isLoading, _) {
                      if (isLoading) {
                        return SizedBox(
                          height: Dimensions.fontSizeDefault,
                          width: Dimensions.fontSizeDefault,
                          child: CircularProgressIndicator(
                            color: widget.textColor,
                            strokeWidth: 2,
                          ),
                        );
                      }

                      return Text(
                        widget.text,
                        style: fontRegular.copyWith(
                          color: widget.textColor,
                          fontFamily: widget.fontFamily,
                          fontSize: widget.fontSize,
                        ),
                      );
                    },
                  )
                else
                  Text(
                    widget.text,
                    style: fontRegular.copyWith(
                      color: widget.textColor,
                      fontFamily: widget.fontFamily,
                      fontSize: widget.fontSize,
                    ),
                  ),

                //? Space only when there is an icon at the start.
                if (widget.spaceEvenly != true &&
                    (widget.endIcon != null || widget.endSvg != null) &&
                    widget.text.isNotEmpty)
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                //? If there is an icon at the end...
                if (widget.endIcon != null && widget.endSvg == null)
                  Icon(
                    widget.endIcon,
                    color: widget.textColor,
                    size: widget.iconSize,
                  ),

                //? If there is SVG imagery at the end...
                if (widget.endSvg != null)
                  SvgPicture.asset(
                    widget.endSvg!,
                    width: widget.iconSize,
                    color: widget.colorSvg ? widget.textColor : null,
                  )
                else if (widget.spaceEvenly == true && (widget.svg != null || widget.startIcon != null))
                  const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined text buttons as they are rendered in the mobile app. Useful utility
/// to create text buttons with outlines.
class OutlinedStyledTextButton extends StyledTextButton {
  const OutlinedStyledTextButton({
    super.key,
    required super.text,
    super.onClick,
    super.type = ButtonType.roundedRectangle,
    super.loadingController,
    super.backgroundColor = Colors.white,
    super.borderColor = ThemeColors.primaryColor,
    super.startIcon,
    super.endIcon,
    super.textColor = Colors.black,
    super.verticalPadding = Dimensions.paddingSizeDefault,
    super.horizontalPadding = Dimensions.paddingSizeDefault,
    super.borderSize = 1,
    super.spaceEvenly,
    super.svg,
    super.constraints,
    super.fontFamily,
    super.endSvg,
    super.colorSvg,
    super.fontSize,
    super.iconSize,
  });
}

/// Utility to create an Icon Button. Useful function to have when working with
/// buttons because it is a shortcut that allows us to bypass most of the
/// difficulties with creating buttons.
class StyledIconButton extends StyledTextButton {
  const StyledIconButton({
    super.key,
    super.text = "",
    super.type = ButtonType.roundedRectangle,
    super.horizontalPadding = Dimensions.paddingSizeDefault,
    super.verticalPadding = Dimensions.paddingSizeSmaller,
    super.colorSvg = true,
    IconData icon = Icons.question_mark_rounded,
    Color iconColor = Colors.white,
    super.borderSize = 1,
    super.onClick,
    super.backgroundColor,
    super.borderColor,
    super.spaceEvenly,
    super.svg,
    super.endSvg,
    super.constraints,
    super.fontSize,
    super.iconSize,
    super.loadingController,
  }) : super(textColor: iconColor, startIcon: icon);
}

/// Utility function to create an IconButton that is outlined and rounded... so
/// to speak. Useful in instances where the kind of button we are looking for is
/// outlined.
class OutlinedStyledIconButton extends StyledTextButton {
  const OutlinedStyledIconButton({
    super.key,
    super.text = "",
    super.type = ButtonType.roundedRectangle,
    super.horizontalPadding = Dimensions.paddingSizeSmall,
    super.verticalPadding = Dimensions.paddingSizeSmall,
    super.backgroundColor = Colors.white,
    super.borderColor = ThemeColors.primaryColor,
    IconData icon = Icons.question_mark_rounded,
    Color iconColor = Colors.black,
    super.borderSize = 1,
    super.endIcon,
    super.spaceEvenly,
    super.fontFamily,
    super.onClick,
    super.svg,
    super.constraints,
    super.endSvg,
    super.fontSize,
    super.colorSvg,
    super.iconSize,
    super.loadingController,
  }) : super(textColor: iconColor, startIcon: icon);
}
