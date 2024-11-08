// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/modals.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';

class OtpTextField extends StatefulWidget {
  final OTPTextController controller;
  final bool obscureText;
  final void Function(String value)? onTextChanged;

  const OtpTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.onTextChanged,
  });

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  bool _isNumeric(String value) {
    return "0123456789".contains(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // For the first OTP.
        Expanded(
          child: TextField(
            textInputAction: TextInputAction.next,
            controller: widget.controller._1Controller,
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            obscuringCharacter: "*",
            obscureText: widget.obscureText,
            focusNode: widget.controller._1Focus,
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (!_isNumeric(value)) {
                  ModalHelper.showSnackBar("An OTP character can only be a number.");
                  widget.controller._1Controller.clear();
                  return;
                }

                widget.onTextChanged?.call(widget.controller.value);
                widget.controller._1Focus.nextFocus();
              }
            },
            decoration: InputDecoration(
              counter: const SizedBox(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorDisabledGray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorTextGray,
                ),
              ),
              hintText: "—",
              hintStyle: const TextStyle(
                color: ThemeColors.colorTextGray,
                fontSize: Dimensions.fontSize2XL,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 11,
              ),
              fillColor: ThemeColors.textfieldFillNormal,
              filled: true,
            ),
            style: const TextStyle(
              color: ThemeColors.colorNeutralDark,
              fontSize: Dimensions.fontSize2XL,
            ),
          ),
        ),

        // Some space.
        const SizedBox(width: Dimensions.paddingSizeDefault),

        // For the second OTP.
        Expanded(
          child: TextField(
            textInputAction: TextInputAction.next,
            controller: widget.controller._2Controller,
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            focusNode: widget.controller._2Focus,
            obscuringCharacter: "*",
            obscureText: widget.obscureText,
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (!_isNumeric(value)) {
                  ModalHelper.showSnackBar("An OTP character can only be a number.");
                  widget.controller._2Controller.clear();
                  return;
                }

                widget.controller._2Focus.nextFocus();
              } else {
                widget.controller._2Focus.previousFocus();
              }

              widget.onTextChanged?.call(widget.controller.value);
            },
            decoration: InputDecoration(
              counter: const SizedBox(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorDisabledGray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorTextGray,
                ),
              ),
              hintText: "—",
              hintStyle: const TextStyle(
                color: ThemeColors.colorTextGray,
                fontSize: Dimensions.fontSize2XL,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 11,
              ),
              fillColor: ThemeColors.textfieldFillNormal,
              filled: true,
            ),
            style: const TextStyle(
              color: ThemeColors.colorNeutralDark,
              fontSize: Dimensions.fontSize2XL,
            ),
          ),
        ),

        // Some space.
        const SizedBox(width: Dimensions.paddingSizeDefault),

        // For the third OTP.
        Expanded(
          child: TextField(
            textInputAction: TextInputAction.next,
            controller: widget.controller._3Controller,
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            focusNode: widget.controller._3Focus,
            obscuringCharacter: "*",
            obscureText: widget.obscureText,
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (!_isNumeric(value)) {
                  ModalHelper.showSnackBar("An OTP character can only be a number.");
                  widget.controller._3Controller.clear();
                  return;
                }

                widget.controller._3Focus.nextFocus();
              } else {
                widget.controller._3Focus.previousFocus();
              }

              widget.onTextChanged?.call(widget.controller.value);
            },
            decoration: InputDecoration(
              counter: const SizedBox(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorDisabledGray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorTextGray,
                ),
              ),
              hintText: "—",
              hintStyle: const TextStyle(
                color: ThemeColors.colorTextGray,
                fontSize: Dimensions.fontSize2XL,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 11,
              ),
              fillColor: ThemeColors.textfieldFillNormal,
              filled: true,
            ),
            style: const TextStyle(
              color: ThemeColors.colorNeutralDark,
              fontSize: Dimensions.fontSize2XL,
            ),
          ),
        ),

        // Some space.
        const SizedBox(width: Dimensions.paddingSizeDefault),

        // For the fourth OTP.
        Expanded(
          child: TextField(
            textInputAction: TextInputAction.done,
            controller: widget.controller._4Controller,
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            focusNode: widget.controller._4Focus,
            obscuringCharacter: "*",
            obscureText: widget.obscureText,
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (!_isNumeric(value)) {
                  ModalHelper.showSnackBar("An OTP character can only be a number.");
                  widget.controller._4Controller.clear();
                  return;
                }

                widget.controller._4Focus.nextFocus();
              } else {
                widget.controller._4Focus.previousFocus();
              }

              widget.onTextChanged?.call(widget.controller.value);
            },
            decoration: InputDecoration(
              counter: const SizedBox(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorDisabledGray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                borderSide: const BorderSide(
                  color: ThemeColors.colorTextGray,
                ),
              ),
              hintText: "—",
              hintStyle: const TextStyle(
                color: ThemeColors.colorTextGray,
                fontSize: Dimensions.fontSize2XL,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 11,
              ),
              fillColor: ThemeColors.textfieldFillNormal,
              filled: true,
            ),
            style: const TextStyle(
              color: ThemeColors.colorNeutralDark,
              fontSize: Dimensions.fontSize2XL,
            ),
          ),
        ),
      ],
    );
  }
}

class OTPTextController {
  final _1Controller = TextEditingController();
  final _2Controller = TextEditingController();
  final _3Controller = TextEditingController();
  final _4Controller = TextEditingController();

  final _1Focus = FocusNode();
  final _2Focus = FocusNode();
  final _3Focus = FocusNode();
  final _4Focus = FocusNode();

  void dispose() {
    _1Controller.dispose();
    _1Focus.dispose();
    _2Controller.dispose();
    _2Focus.dispose();
    _3Controller.dispose();
    _3Focus.dispose();
    _4Controller.dispose();
    _4Focus.dispose();
  }

  void clear() {
    _1Controller.clear();
    _2Controller.clear();
    _3Controller.clear();
    _4Controller.clear();
    _1Focus.requestFocus();
  }

  /// A utility used to fetch if this OTP textfield has been filled completely.
  bool get isComplete => value.length == 4;

  /// A utility used to fetch the current value of this OTP text field.
  String get value => "${_1Controller.text}${_2Controller.text}${_3Controller.text}${_4Controller.text}";
}
