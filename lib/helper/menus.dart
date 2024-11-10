import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:msbm_assessment_test/controllers/filesystem.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/modals.dart';

/// A class that contains absolutely ALL the context menus that are available in
/// the app AND used inside of the app.
class ContextMenuHelper {
  /// The context menu used when interacting with files. Should have any and all
  /// popular file operations.
  static ContextMenu getFileMenu(File file) {
    final controller = AppRegistry.find<FilesystemController>();
    final entries = <ContextMenuEntry>[
      //? First, the header.
      MenuHeader(
        text: "File options",
      ),

      // The separator.
      const MenuDivider(),

      //? Second, the delete button.
      MenuItem(
        label: "Delete",
        icon: Icons.delete_forever,
        onSelected: () {
          try {
            file.deleteSync();
            ModalHelper.showSnackBar("File deleted successfully", false);
            controller.silentSyncChanges();
          } catch (e) {
            ModalHelper.showSnackBar("Failed to delete file");
          }
        },
      ),
    ];

    //? This is fine.
    return ContextMenu(
      entries: entries,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    );
  }

  /// The context menu used when interacting with folder. Should have any and all
  /// popular folder operations.
  static ContextMenu getFolderMenu(Directory file) {
    final entries = <ContextMenuEntry>[
      //? First, the header.
      MenuHeader(
        text: "Folder options",
      ),
    ];

    //? This is fine.
    return ContextMenu(
      entries: entries,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    );
  }
}
