import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

/// A widget that is used to show whether or not a given entity is synchronized
/// with the remote.
class FileSyncedCard extends StatelessWidget {
  final bool isSynced;

  const FileSyncedCard({
    super.key,
    required this.isSynced,
  });

  @override
  Widget build(BuildContext context) {
    // This is fine.
    final surfaceColor = isSynced ? ThemeColors.colorSuccessSubtle : ThemeColors.colorErrorSubtle;

    // This is fine.
    final textColor = isSynced ? ThemeColors.successColor : ThemeColors.errorColor;

    // This is fine.
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeExtraSmall,
        horizontal: Dimensions.paddingSizeSmaller,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusInfinite),
        border: Border.all(color: textColor),
        color: surfaceColor,
      ),
      child: Text(
        isSynced ? "Synced" : "Not synced",
        style: fontRegular.copyWith(
          fontSize: Dimensions.fontSizeEvenSmaller,
          color: textColor,
        ),
      ),
    );
  }
}
