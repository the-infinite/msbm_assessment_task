import 'dart:async';

import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';

/// A helper Widget used to build a checkbox that has been styled with the design
/// system and theme in mind.
class StyledCheckbox extends StatefulWidget {
  /// Callback that should be made when the value of the data inside this
  /// checkbox changes
  final ValueNotifier<bool?> changeNotifier;

  /// Does this checkbox have 3 states?
  final bool tristate;

  /// What to do when this changes.
  final void Function(bool?)? onChanged;

  // Construct.
  const StyledCheckbox({
    super.key,
    required this.changeNotifier,
    this.tristate = false,
    this.onChanged,
  });

  @override
  State<StyledCheckbox> createState() => _StyledCheckboxState();
}

class _StyledCheckboxState extends State<StyledCheckbox> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.changeNotifier,
      builder: (context, isActive, _) {
        return Checkbox(
          value: widget.tristate ? isActive : isActive ?? false,
          tristate: widget.tristate,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              //? If this is selected...
              if (states.contains(MaterialState.selected)) {
                return ThemeColors.primaryColor;
              }

              // Since it is not.
              return ThemeColors.colorErrorSubtle;
            },
          ),
          side: const BorderSide(
            color: ThemeColors.colorErrorSurfaceLighter,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          onChanged: (value) {
            widget.changeNotifier.value = value;
            widget.onChanged?.call(value);
          },
        );
      },
    );
  }
}

class StyledRoundCheckbox extends StatefulWidget {
  /// Callback that should be made when the value of the data inside this
  /// checkbox changes
  final ValueNotifier<bool?> changeNotifier;

  /// Does this checkbox have 3 states?
  final bool tristate;

  /// Somehow, we need to make the space around this variable.
  final double margins;

  /// A function used to do some additional actions whenever the state of this
  /// element is changed.
  final FutureOr<bool> Function(bool? value)? onChanged;

  /// Construct.
  const StyledRoundCheckbox({
    super.key,
    required this.changeNotifier,
    this.tristate = false,
    this.margins = 0,
    this.onChanged,
  });

  @override
  State<StyledRoundCheckbox> createState() => _StyledRoundCheckboxState();
}

class _StyledRoundCheckboxState extends State<StyledRoundCheckbox> {
  @override
  Widget build(BuildContext context) {
    bool loading = false;

    return ValueListenableBuilder(
      valueListenable: widget.changeNotifier,
      builder: (context, isActive, _) {
        return Checkbox(
          value: widget.tristate ? isActive : isActive ?? false,
          tristate: widget.tristate,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashRadius: widget.margins,
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              //? If this is selected...
              if (states.contains(MaterialState.selected)) {
                return ThemeColors.primaryColor;
              }

              // Since it is not.
              return Colors.transparent;
            },
          ),
          side: BorderSide(
            color: isActive == true ? ThemeColors.primaryColor : ThemeColors.colorTextGray,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
          ),
          onChanged: (value) async {
            // Leave, if we are already doing this.
            if (loading) return;

            // Now we are loading.
            loading = true;

            //? Try this.
            if (widget.onChanged != null) {
              // Obtain the result.
              final result = await widget.onChanged!.call(value);

              // This is fine too.
              loading = false;

              // Leave if this failed.
              if (!result) return;
            }

            // This is fine.
            loading = false;

            // This is fine.
            widget.changeNotifier.value = value;
          },
        );
      },
    );
  }
}

/// A helper Widget used to build a checkbox that has been styled with the design
/// system and theme in mind.
class StyledRadioButton<T> extends StatefulWidget {
  /// Callback that shouold be made when the value of the data inside this
  /// checkbox changes
  final void Function(T?) onChanged;

  /// The value of the radiogroup this comes from.
  final T? groupValue;

  /// The value of this radio button.
  final T value;

  const StyledRadioButton({
    super.key,
    required this.onChanged,
    required this.value,
    this.groupValue,
  });

  @override
  State<StyledRadioButton<T>> createState() => _StyledRadioButtonState<T>();
}

class _StyledRadioButtonState<T> extends State<StyledRadioButton<T>> {
  T? isActive;

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      value: widget.value,
      groupValue: widget.groupValue,
      fillColor: MaterialStateColor.resolveWith((states) {
        //? If this is selected...
        if (states.contains(MaterialState.selected)) {
          return ThemeColors.primaryColor;
        }

        // Since it is not.
        return ThemeColors.colorErrorSurfaceLighter;
      }),
      onChanged: (value) {
        setState(() {
          isActive = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
