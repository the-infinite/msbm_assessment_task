import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/regions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/widgets/compose/country_code_picker.dart';

enum TextFieldState {
  normal,
  error,
  success,
}

/// A styled text field. Useful for instantly dropping text fields into the scope
/// which are appropriately themed to match the style guides.
class StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final ValueNotifier<TextFieldState>? stateNotifier;
  final ValueNotifier<String>? helperNotifier;
  final IconData? icon;
  final Color? borderColor;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final void Function(String)? onTextChanged;
  final bool enabled;
  final int maxLines;

  // This is fine.
  const StyledTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputAction = TextInputAction.done,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
    this.onTextChanged,
    this.stateNotifier,
    this.helperNotifier,
    this.icon,
    this.borderColor,
  });

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  bool canCancel = false;

  void onTextChanged(String text) {
    widget.onTextChanged?.call(text);
    setState(() {
      canCancel = text.length > 1;
    });
  }

  void _listener() {
    onTextChanged(widget.controller.text);
  }

  @override
  void initState() {
    super.initState();

    // This is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _listener();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // What we return.
    return ValueListenableBuilder(
      valueListenable: widget.stateNotifier ?? ValueNotifier(TextFieldState.normal),
      builder: (context, textState, _) {
        return ValueListenableBuilder(
          valueListenable: widget.helperNotifier ?? ValueNotifier(""),
          builder: (context, helperText, _) {
            // The color we would be using to accentuate the correct look of this
            // text field.
            final accentColor = textState == TextFieldState.error
                ? ThemeColors.errorColor
                : textState == TextFieldState.success
                    ? ThemeColors.successColor
                    : ThemeColors.colorTextGray;

            // The fill color we would be using for the button.
            final fillColor = textState == TextFieldState.error
                ? ThemeColors.textfieldFillError
                : textState == TextFieldState.success
                    ? ThemeColors.textfieldFillSuccess
                    : ThemeColors.textfieldFillNormal;

            return TextField(
              textInputAction: widget.inputAction,
              controller: widget.controller,
              keyboardType: widget.inputType,
              enabled: widget.enabled,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (value) {
                onTextChanged(value);
              },
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? accentColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: widget.borderColor == null
                      ? BorderSide.none
                      : BorderSide(
                          color: widget.borderColor!,
                        ),
                ),
                prefixIcon: widget.icon != null
                    ? Icon(
                        widget.icon!,
                        size: 20,
                        color: ThemeColors.textfieldIconColor,
                      )
                    : null,
                suffixIcon: canCancel
                    ? InkWell(
                        onTap: () {
                          widget.controller.clear();
                          onTextChanged("");
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: ThemeColors.textfieldIconColor,
                        ),
                      )
                    : null,
                labelText: widget.labelText,
                floatingLabelStyle: fontRegular.copyWith(
                  color: accentColor,
                  fontSize: Dimensions.fontSizeDefault,
                ),
                labelStyle: fontRegular.copyWith(
                  color: ThemeColors.textfieldLabelColor,
                  fontSize: Dimensions.fontSizeDefault,
                ),
                helperText: textState == TextFieldState.normal ? null : helperText,
                helperStyle: fontRegular.copyWith(
                  color: accentColor,
                  fontSize: Dimensions.fontSizeSmall,
                ),
                fillColor: fillColor,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              style: fontRegular.copyWith(
                color: ThemeColors.colorNeutralDark,
              ),
            );
          },
        );
      },
    );
  }
}

/// A styled password textfield. Useful for quickly dropping password text
/// fields into screens with minimal configuration required.
class StyledPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final ValueNotifier<TextFieldState>? stateNotifier;
  final ValueNotifier<String>? helperNotifier;
  final IconData? icon;
  final TextInputAction inputAction;
  final void Function(String)? onTextChanged;

  const StyledPasswordTextField({
    super.key,
    required this.controller,
    this.labelText = "Password",
    this.inputAction = TextInputAction.done,
    this.onTextChanged,
    this.stateNotifier,
    this.helperNotifier,
    this.icon,
  });

  @override
  State<StyledPasswordTextField> createState() => _StyledPasswordTextFieldState();
}

class _StyledPasswordTextFieldState extends State<StyledPasswordTextField> {
  bool isHidden = true;

  void toggleHidden() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.stateNotifier ?? ValueNotifier(TextFieldState.normal),
      builder: (context, textState, _) {
        return ValueListenableBuilder(
          valueListenable: widget.helperNotifier ?? ValueNotifier(""),
          builder: (context, helperText, _) {
            // The color we would be using to accentuate the correct look of this
            // text field.
            final accentColor = textState == TextFieldState.error
                ? ThemeColors.errorColor
                : textState == TextFieldState.success
                    ? ThemeColors.successColor
                    : ThemeColors.colorTextGray;

            // The fill color we would be using for the button.
            final fillColor = textState == TextFieldState.error
                ? ThemeColors.textfieldFillError
                : textState == TextFieldState.success
                    ? ThemeColors.textfieldFillSuccess
                    : ThemeColors.textfieldFillNormal;

            return TextField(
              textInputAction: widget.inputAction,
              controller: widget.controller,
              keyboardType: TextInputType.visiblePassword,
              onChanged: widget.onTextChanged,
              obscureText: isHidden,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide(
                    color: accentColor,
                  ),
                ),
                prefixIcon: widget.icon != null
                    ? Icon(
                        widget.icon!,
                        size: 20,
                        color: ThemeColors.textfieldIconColor,
                      )
                    : null,
                suffixIcon: InkWell(
                  onTap: toggleHidden,
                  child: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: ThemeColors.textfieldIconColor,
                  ),
                ),
                labelText: widget.labelText,
                floatingLabelStyle: TextStyle(
                  color: accentColor,
                  fontSize: Dimensions.fontSizeDefault,
                ),
                labelStyle: const TextStyle(
                  color: ThemeColors.textfieldLabelColor,
                  fontSize: Dimensions.fontSizeDefault,
                ),
                helperText: textState == TextFieldState.normal ? null : helperText,
                helperStyle: TextStyle(
                  color: accentColor,
                  fontSize: Dimensions.fontSizeSmall,
                ),
                fillColor: fillColor,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              style: const TextStyle(
                color: ThemeColors.colorNeutralDark,
              ),
            );
          },
        );
      },
    );
  }
}

/// A styled phone number text field that should easily allow us to include a
/// phone number text field with minimal to zero effort.
class StyledPhoneTextField extends StatefulWidget {
  final PhoneTextFieldController controller;
  final String labelText;
  final ValueNotifier<TextFieldState>? stateNotifier;
  final ValueNotifier<String>? helperNotifier;
  final IconData? icon;
  final TextInputAction inputAction;
  final void Function(String)? onTextChanged;
  final ValueNotifier<Country?> countryController;
  final List<Country> countries;
  final bool enabled;

  const StyledPhoneTextField({
    super.key,
    required this.controller,
    required this.countries,
    required this.countryController,
    this.labelText = "Phone number",
    this.inputAction = TextInputAction.done,
    this.enabled = true,
    this.onTextChanged,
    this.stateNotifier,
    this.helperNotifier,
    this.icon,
  });

  @override
  State<StyledPhoneTextField> createState() => _StyledPhoneTextFieldState();
}

class _StyledPhoneTextFieldState extends State<StyledPhoneTextField> {
  bool bottomSheetOpen = false;

  @override
  void initState() {
    super.initState();

    //? If there isn't a single country....
    if (widget.countries.isEmpty) {
      throw Exception("Countries in a phone number textfield cannot be blank");
    }

    // The initially selected country would be the first country.
    widget.controller._currentCountry ??= widget.countries.first;
    widget.countryController.value ??= widget.controller._currentCountry;
  }

  void chooseCountry(BuildContext context) async {
    // Set the state of this one.
    setState(() {
      bottomSheetOpen = true;
    });

    // Do this fairly.
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return CountryCodePicker(
          controller: widget.countryController,
          countries: widget.countries,
          dismiss: () {
            AppRegistry.nav.pop();
          },
        );
      },
    );

    // Dismiss this lad.
    setState(() {
      bottomSheetOpen = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The initially selected country would be the first country.
    widget.controller._currentCountry ??= widget.countries.first;
    widget.countryController.value ??= widget.controller._currentCountry;

    //? Now build this.
    return ValueListenableBuilder(
      valueListenable: widget.stateNotifier ?? ValueNotifier(TextFieldState.normal),
      builder: (context, textState, _) {
        return ValueListenableBuilder(
          valueListenable: widget.helperNotifier ?? ValueNotifier(""),
          builder: (context, helperText, _) {
            // The color we would be using to accentuate the correct look of this
            // text field.
            final accentColor = textState == TextFieldState.error
                ? ThemeColors.errorColor
                : textState == TextFieldState.success
                    ? ThemeColors.successColor
                    : ThemeColors.colorTextGray;

            // The fill color we would be using for the button.
            final fillColor = textState == TextFieldState.error
                ? ThemeColors.textfieldFillError
                : textState == TextFieldState.success
                    ? ThemeColors.textfieldFillSuccess
                    : ThemeColors.textfieldFillNormal;

            return TextField(
              textInputAction: widget.inputAction,
              controller: widget.controller._textController,
              keyboardType: TextInputType.phone,
              onChanged: widget.onTextChanged,
              enabled: widget.enabled,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  borderSide: BorderSide(
                    color: accentColor,
                  ),
                ),
                prefixIcon: InkWell(
                  onTap: () => chooseCountry(context),
                  child: IntrinsicHeight(
                    child: ValueListenableBuilder(
                        valueListenable: widget.countryController,
                        builder: (context, currentCountry, _) {
                          // Update this one.
                          widget.controller._currentCountry = currentCountry;

                          // Return this one.
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Some space first.
                              const SizedBox(
                                width: Dimensions.paddingSizeSmall,
                              ),

                              // Show the flag
                              SvgPicture.asset(
                                currentCountry!.flag,
                                height: Dimensions.fontSizeDefault,
                              ),

                              //
                              const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall,
                              ),

                              // Something else to go here.
                              Text(
                                currentCountry.dialCode,
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Colors.black,
                                ),
                              ),

                              // Some more space...
                              const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall,
                              ),

                              //? Now for the caret icon.
                              Icon(
                                bottomSheetOpen ? CupertinoIcons.chevron_left : CupertinoIcons.chevron_down,
                                size: Dimensions.fontSizeDefault,
                                color: ThemeColors.textfieldColor,
                              ),

                              //? Now for some space.
                              Padding(
                                padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall,
                                ),
                                child: VerticalDivider(
                                  color: Theme.of(context).disabledColor,
                                  thickness: 2,
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                hintText: widget.labelText,
                labelStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: Dimensions.fontSizeDefault,
                ),
                helperText: textState == TextFieldState.normal ? null : helperText,
                helperStyle: TextStyle(
                  color: accentColor,
                  fontSize: Dimensions.fontSizeSmall,
                ),
                fillColor: fillColor,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              style: const TextStyle(
                color: ThemeColors.colorNeutralDark,
              ),
            );
          },
        );
      },
    );
  }
}

/// A utility class that is used to abstract away the retrieval of
/// a user's country code from our custom country code selection
/// field.
class PhoneTextFieldController {
  final _textController = TextEditingController();
  Country? _currentCountry;

  void dispose() {
    _textController.dispose();
  }

  // This is fine.
  PhoneTextFieldController([String? phone]) {
    if (phone == null) {
      return;
    }

    //? If this starts with +234.
    if (phone.startsWith("+234")) {
      _textController.text = phone.substring(4);
      _currentCountry = AppConstants.servedRegions.firstWhere((country) => country.dialCode == "+234");
    }

    //? If this does not start with +234...
    else {
      _textController.text = phone.substring(3);
      _currentCountry = AppConstants.servedRegions.firstWhere((country) => country.dialCode == "+44");
    }
  }

  /// The phone number currently in the text editing controller.
  /// Including its country code.
  String get phoneNumber {
    String phone = _textController.text;

    //? If it starts with a 0, remove the 0.
    if (phone.startsWith("0")) {
      phone = phone.substring(1);
    }

    // Build it up this way.
    phone = "${currentCountry.dialCode}$phone";

    // Return the trimmed out phone number.
    return phone;
  }

  /// The currently selected country by this controller.
  Country get currentCountry => _currentCountry!;

  /// The phone number of this controller without the country code.
  String get phoneWithoutDialCode => _textController.text;
}

/// A class used to represent the controller of a search text field.
class SearchTextController {
  final _textController = TextEditingController();
  _StyledSearchTextFieldState? _textField;

  /// Retrieves the text currently stored in this search controller.
  String get text => _textController.text.trim();

  /// Sets the text currently stored in this text controller.
  set text(String value) {
    _textController.text = value;
    _textField?.canCancel.value = value.length > 1;
  }

  /// Removes all the text in the associated [StyledSearchTextField].
  void clear() {
    _textController.clear();
    _textField?.canCancel.value = false;
  }

  void dispose() {
    try {
      _textController.dispose();
    } catch (_) {}
  }

  /// Construct.
  SearchTextController();
}

/// A styled search textfield that should be used in places where a search
/// action would probably be appreciated.
class StyledSearchTextField extends StatefulWidget {
  final String labelText;
  final ValueNotifier<TextFieldState>? stateNotifier;
  final TextInputAction inputAction;
  final void Function(String)? onQueryBuilt;
  final void Function()? onSearchClicked;
  final void Function()? onCancelClicked;
  final BoxConstraints? constraints;
  final SearchTextController textController;
  final double verticalPadding;
  final double horizontalPadding;
  final Duration debounceTimer;
  final bool enabled;

  const StyledSearchTextField({
    super.key,
    required this.textController,
    this.labelText = "Search",
    this.inputAction = TextInputAction.search,
    this.debounceTimer = const Duration(milliseconds: 800),
    this.verticalPadding = Dimensions.paddingSizeDefault,
    this.horizontalPadding = Dimensions.paddingSizeDefault,
    this.enabled = true,
    this.constraints,
    this.onSearchClicked,
    this.onQueryBuilt,
    this.onCancelClicked,
    this.stateNotifier,
  });

  @override
  State createState() => _StyledSearchTextFieldState();
}

class _StyledSearchTextFieldState extends State<StyledSearchTextField> {
  final canCancel = ValueNotifier(false);
  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();

    // We remember to set this state like this.
    widget.textController._textField = this;
  }

  /// Remove the previous overlay.
  @override
  void dispose() {
    super.dispose();

    // That is the case.
    canCancel.dispose();
  }

  void debounceQuery(String value) {
    // First, cancel the previous timer.
    debounceTimer?.cancel();

    //? If there's nothing there...
    if (value.trim().isEmpty) {
      return;
    }

    // Next, apply the timer all over again.
    debounceTimer = Timer(
      widget.debounceTimer,
      () {
        if (value.trim().isEmpty) {
          return;
        }
        widget.onQueryBuilt?.call(value.trim());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: canCancel,
      builder: (context, textState, _) {
        const accentColor = ThemeColors.colorTextGray;
        const fillColor = ThemeColors.textfieldFillNormal;

        return Material(
          child: TextField(
            textInputAction: widget.inputAction,
            controller: widget.textController._textController,
            keyboardType: TextInputType.streetAddress,
            onChanged: (value) {
              canCancel.value = value.length > 1;
              debounceQuery(value);
            },
            enabled: widget.enabled,
            decoration: InputDecoration(
              constraints: widget.constraints,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
                vertical: widget.verticalPadding,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: const BorderSide(
                  color: ThemeColors.hintColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: const BorderSide(
                  color: ThemeColors.colorDisabledGray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: const BorderSide(
                  color: accentColor,
                ),
              ),
              prefixIcon: InkWell(
                onTap: widget.onSearchClicked,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmaller),
                  child: SvgPicture.asset(
                    AppIcons.search,
                    height: Dimensions.fontSizeDefault,
                  ),
                ),
              ),
              suffixIcon: canCancel.value
                  ? InkWell(
                      onTap: () {
                        widget.textController.clear();
                        widget.onCancelClicked?.call();
                      },
                      child: const Icon(
                        Icons.close,
                        size: Dimensions.fontSizeExtraLarge,
                        color: ThemeColors.textfieldIconColor,
                      ),
                    )
                  : null,
              labelText: widget.labelText,
              labelStyle: const TextStyle(
                color: ThemeColors.textfieldLabelColor,
                fontSize: Dimensions.fontSizeSmall,
              ),
              floatingLabelStyle: const TextStyle(
                color: accentColor,
                fontSize: Dimensions.fontSizeDefault,
              ),
              fillColor: fillColor,
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            style: const TextStyle(
              color: ThemeColors.colorNeutralDark,
            ),
          ),
        );
      },
    );
  }
}
