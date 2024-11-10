import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/controllers/filesystem.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/menus.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/helper/time.dart';
import 'package:msbm_assessment_test/widgets/cards/file.dart';

class DirectoryEntryWidget extends StatelessWidget {
  final FileSystemEntity data;
  final bool isParent;

  const DirectoryEntryWidget({
    super.key,
    required this.data,
    this.isParent = false,
  });

  @override
  Widget build(BuildContext context) {
    //? Check if this is a directory...
    final isDirectory = data.statSync().type == FileSystemEntityType.directory;
    final controller = AppRegistry.find<FilesystemController>();

    //? If this is a directory..
    if (isDirectory) {
      return _DirectoryWidget(
        data: Directory(data.path).absolute,
        controller: controller,
        isParent: isParent,
      );
    }

    //? This is fine.
    return _FileWidget(
      data: File(data.path).absolute,
      controller: controller,
    );
  }
}

class _DirectoryWidget extends StatelessWidget {
  final Directory data;
  final FilesystemController controller;
  final bool isParent;

  // Construct.
  const _DirectoryWidget({
    required this.data,
    required this.controller,
    required this.isParent,
  });

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final stat = data.statSync();

    //? Build and return the widget.
    return InkWell(
      onTap: () {
        controller.setPath(data.path);
      },
      child: isParent
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //? First, the icon.
                SvgPicture.asset(
                  isParent ? AppIcons.folderUp : AppIcons.folder,
                  color: ThemeColors.blueColor,
                  height: Dimensions.fontSize5XL,
                ),

                // Some space.
                const SizedBox(width: Dimensions.paddingSizeDefault),

                //? Next, the filename.
                Text(
                  isParent ? ".." : controller.getFilename(data.path),
                  style: fontRegular.copyWith(
                    color: ThemeColors.colorNeutralDark,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),

                // Next, boundless space.
                const Spacer(),

                //? Next, the synced card.
                FileSyncedCard(
                  isSynced: controller.isSynced(data),
                ),

                // Some space.
                const SizedBox(width: Dimensions.paddingSizeDefault),

                //? Next, the filename.
                Text(
                  "Last modified: ${DateTimeHelper.getFullTimestamp(stat.modified)}",
                  style: fontRegular.copyWith(
                    color: ThemeColors.colorNeutralDark,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ],
            )
          : ContextMenuRegion(
              contextMenu: ContextMenuHelper.getFolderMenu(data),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //? First, the icon.
                  SvgPicture.asset(
                    isParent ? AppIcons.folderUp : AppIcons.folder,
                    color: ThemeColors.blueColor,
                    height: Dimensions.fontSize5XL,
                  ),

                  // Some space.
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  //? Next, the filename.
                  Text(
                    isParent ? ".." : controller.getFilename(data.path),
                    style: fontRegular.copyWith(
                      color: ThemeColors.colorNeutralDark,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),

                  // Next, boundless space.
                  const Spacer(),

                  //? Next, the synced card.
                  FileSyncedCard(
                    isSynced: controller.isSynced(data),
                  ),

                  // Some space.
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  //? Next, the filename.
                  Text(
                    "Last modified: ${DateTimeHelper.getFullTimestamp(stat.modified)}",
                    style: fontRegular.copyWith(
                      color: ThemeColors.colorNeutralDark,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _FileWidget extends StatelessWidget {
  final File data;
  final FilesystemController controller;

  // Construct.
  const _FileWidget({
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: ContextMenuHelper.getFileMenu(data),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //? First, the icon.
          SvgPicture.asset(
            AppIcons.file,
            color: ThemeColors.brownColor,
            height: Dimensions.fontSize5XL,
          ),

          // Some space.
          const SizedBox(width: Dimensions.paddingSizeDefault),

          //? Next, the filename.
          Text(
            controller.getFilename(data.path),
            style: fontRegular.copyWith(
              color: ThemeColors.colorNeutralDark,
              fontSize: Dimensions.fontSizeLarge,
            ),
          ),

          // Next, boundless space.
          const Spacer(),

          //? Next, the synced card.
          FileSyncedCard(
            isSynced: controller.isSynced(data),
          ),

          // Some space.
          const SizedBox(width: Dimensions.paddingSizeDefault),

          //? Next, the filename.
          Text(
            "Last modified: ${DateTimeHelper.getFullTimestamp(data.lastModifiedSync())}",
            style: fontRegular.copyWith(
              color: ThemeColors.colorNeutralDark,
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        ],
      ),
    );
  }
}
