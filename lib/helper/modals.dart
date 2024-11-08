import 'dart:async';

import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/widget/boundary.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/widgets/compose/error_dialog.dart';
import 'package:msbm_assessment_test/widgets/compose/option_dialog.dart';

class ModalHelper {
  ModalHelper._();

  /// A utility function used to show a snackbar using the themes error or success
  ///  colors as appropriate.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, [
    bool? isError = true,
    SnackBarAction? action,
  ]) {
    return AppRegistry.showSnackbar(
      icon: isError == null
          ? AppIcons.tooltip
          : isError
              ? AppIcons.caution
              : AppIcons.stateLoaded,
      message: message,
      backgroundColor: isError == null
          ? Colors.black
          : isError
              ? ThemeColors.errorColor
              : ThemeColors.successColor,
      action: action,
    );
  }

  /// A utility function used to show a bottom sheet that is used to confirm if
  /// the user is willing to move forward with an action after understanding what
  /// it is.
  static Future showChoiceDialog(
    String title,
    String subtitle, {
    String negativeText = "Cancel",
    String positiveText = "Yes",
    required FutureOr<bool> Function() onConfirm,
    required VoidCallback onReject,
  }) {
    return showCustomDialog(
      ChooseOptionDialogWidget(
        title: title,
        subtitle: subtitle,
        positiveText: positiveText,
        negativeText: negativeText,
        onConfirm: onConfirm,
        onDeny: onReject,
      ),
    );
  }

  /// A utility function used to show a bottom sheet that is used to show errors
  /// after they happen ot kind of give the user a sense of what is going on.
  static Future showErrorDialog(
    String message, [
    String title = "Oops! An error occurred.",
    String? buttonText,
    VoidCallback? onButtonClicked,
  ]) {
    return showCustomDialog(
      ErrorDialogWidget(
        message: message,
        title: title,
        buttonText: buttonText,
        onButtonClicked: onButtonClicked,
      ),
    );
  }

  /// A utility function used to show a bottom sheet that is used to show success
  /// messages after something worked perfectly.
  static Future showSuccessDialog(
    String message, [
    String title = "Yay!",
    String? primaryButtonText,
    VoidCallback? onPrimaryButtonClicked,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonClicked,
    VoidCallback? onDismiss,
  ]) {
    return showCustomDialog(
      SuccessDialogWidget(
        message: message,
        title: title,
        primaryButtonText: primaryButtonText,
        onPrimaryButtonClicked: onPrimaryButtonClicked,
        secondaryButtonText: secondaryButtonText,
        onSecondaryButtonClicked: onSecondaryButtonClicked,
        onDismiss: onDismiss,
      ),
    );
  }

  /// A utility function used to show a bottom sheet that is used to show success
  /// messages after something worked perfectly.
  static Future<T?> showCustomDialog<T>(
    Widget dialog, [
    bool isDismissible = true,
  ]) {
    return showDialog<T>(
      context: AppRegistry.context!,
      barrierDismissible: isDismissible,
      barrierColor: Colors.black54,
      builder: (context) {
        return InterceptorBoundary(
          canPop: isDismissible,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            insetPadding: const EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeDefault,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 500,
                maxWidth: 500,
                minHeight: 0,
                maxHeight: 700,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: dialog,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
