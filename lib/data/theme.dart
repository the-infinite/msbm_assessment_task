import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';

class ThemeState extends ObjectState {
  late ThemeData value;
  bool isDark = false;

  /// The default constructor used inside of this particular theme data.
  ThemeState({this.isDark = false}) {
    _setData(isDark);
  }

  @override
  ThemeState.fromState(SavedStateData savedState) {
    isDark = savedState["isDark"] ?? false;
    _setData(isDark);
  }

  void _setData(bool isDarkThemeEnabled) {
    if (isDarkThemeEnabled) {
      value = ThemeData(
        fontFamily: AppConstants.fontFamily,
        primaryColor: ThemeColors.primaryColor,
        secondaryHeaderColor: const Color(0xFF009f67),
        disabledColor: ThemeColors.colorTextGray,
        brightness: Brightness.dark,
        hintColor: const Color(0xFF7C7C7C),
        cardColor: const Color(0xFF292929),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ThemeColors.primaryColor,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: ThemeColors.primaryColor,
          secondary: ThemeColors.primaryColor,
        ).copyWith(error: ThemeColors.errorColor),
      );
    } else {
      value = ThemeData(
        fontFamily: AppConstants.fontFamily,
        primaryColor: ThemeColors.primaryColor,
        secondaryHeaderColor: const Color(0xFF1ED7AA),
        disabledColor: ThemeColors.colorTextGray,
        brightness: Brightness.light,
        hintColor: const Color(0xFF7C7C7C),
        cardColor: Colors.white,
        chipTheme: const ChipThemeData(
          selectedColor: ThemeColors.primaryColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ThemeColors.primaryColor,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: ThemeColors.primaryColor,
          secondary: ThemeColors.primaryColor,
        ).copyWith(error: ThemeColors.errorColor),
      );
    }
  }

  @override
  SavedStateData toSavedState() {
    return {
      "isDark": isDark,
    };
  }
}
