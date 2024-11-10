import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/modals.dart';
import 'package:url_launcher/url_launcher.dart';

/// A class that contains absolutely ALL the context menus that are available in
/// the app AND used inside of the app.
class ContextMenuHelper {
  /// The context menu used when interacting with files. Should have any and all
  /// popular file operations.
  static ContextMenu getFileMenu(File file) {
    final entries = <ContextMenuEntry>[
      //? First, the header.
      MenuHeader(
        text: "File options",
      ),

      // The separator.
      const MenuDivider(),

      //? Second, the delete button.
      // This is fine.
      MenuItem.submenu(
        label: 'Open...',
        icon: Icons.folder_open_rounded,
        items: [
          MenuHeader(
            text: "Open file",
          ),

          // The separator.
          const MenuDivider(),

          // This is fine.
          MenuItem(
            label: 'Open with Platform',
            value: "open_file",
            icon: Icons.open_in_browser_rounded,
            onSelected: () {
              launchUrl(file.uri);
            },
          ),
          MenuItem(
            label: 'Open Containing Folder',
            value: 'open_containing_folder',
            icon: Icons.file_open_rounded,
            onSelected: () {
              launchUrl(file.parent.uri);
            },
          ),
        ],
      ),

      //? Second, the delete button.
      MenuItem(
        label: "Delete",
        icon: Icons.delete_forever,
        onSelected: () {
          try {
            file.deleteSync();
            ModalHelper.showSnackBar("File deleted successfully", false);
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
      maxWidth: 300,
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

      // The separator.
      const MenuDivider(),

      //? Second, the delete button.
      // This is fine.
      MenuItem.submenu(
        label: 'Open...',
        icon: Icons.folder_open_rounded,
        items: [
          MenuHeader(
            text: "Open folder",
          ),

          // The separator.
          const MenuDivider(),

          // This is fine.
          MenuItem(
            label: 'Open in File Manager',
            value: "open_file",
            icon: Icons.open_in_browser_rounded,
            onSelected: () {
              launchUrl(file.uri);
            },
          ),
          MenuItem(
            label: 'Open Containing Folder',
            value: 'open_containing_folder',
            icon: Icons.file_open_rounded,
            onSelected: () {
              launchUrl(file.parent.uri);
            },
          ),
        ],
      ),

      //? Second, the delete button.
      MenuItem(
        label: "Delete",
        icon: Icons.delete_forever,
        onSelected: () {
          try {
            file.deleteSync(recursive: true);
            ModalHelper.showSnackBar("Folder deleted successfully", false);
          } catch (e) {
            ModalHelper.showSnackBar("Failed to delete folder");
          }
        },
      ),
    ];

    //? This is fine.
    return ContextMenu(
      entries: entries,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      maxWidth: 300,
    );
  }
}
