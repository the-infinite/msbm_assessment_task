import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';

/// A class that contains absolutely ALL the context menus that are available in
/// the app AND used inside of the app.
class ContextMenuHelper {
  /// The context menu used when interacting with files. Should have any and all
  /// popular file operations.
  ContextMenu getFileMenu(File file) {
    final entries = <ContextMenuEntry>[
      //? First, the header.
      const MenuHeader(text: "File options"),
    ];

    //? This is fine.
    return ContextMenu(
      entries: entries,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    );
  }
}
