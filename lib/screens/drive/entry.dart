import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/controllers/filesystem.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/state/single_subscriber.dart';
import 'package:msbm_assessment_test/core/widget/future.dart';
import 'package:msbm_assessment_test/core/widget/stream.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/modals.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/helper/text.dart';
import 'package:msbm_assessment_test/models/filesystem.dart';
import 'package:msbm_assessment_test/screens/drive/widget/entity.dart';
import 'package:msbm_assessment_test/screens/errors/unknown.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';
import 'package:msbm_assessment_test/widgets/themed/textfield.dart';

class DriveScreen extends StatelessWidget {
  const DriveScreen({super.key});

  /// Utility function used to create a folder in a specific path.
  void _createFolder(String root, FilesystemController controller) async {
    // Next, for this one.
    final directory = Directory(root);
    final nameController = TextEditingController();
    final nameStateNotifier = ValueNotifier(TextFieldState.normal);
    final nameErrorController = ValueNotifier("The name of the folder cannot be blank.");

    //? Next, do the needful here.
    final result = await ModalHelper.showCustomDialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The title text here.
          Text(
            "Create folder",
            textAlign: TextAlign.center,
            style: fontSemiBold.copyWith(
              fontSize: Dimensions.fontSizeOverLarge,
            ),
          ),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Then a divider.
          const Divider(color: ThemeColors.colorTextGray, thickness: 1, height: 0),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          //? First, the name controller.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // First, we have this one...
              Expanded(
                child: StyledTextField(
                  controller: nameController,
                  labelText: "Name",
                  stateNotifier: nameStateNotifier,
                  helperNotifier: nameErrorController,
                ),
              ),

              // Some space.
              const SizedBox(width: Dimensions.paddingSizeDefault),

              // Finally, the paste button.
              StyledTextButton(
                text: "Paste",
                svg: AppIcons.clipboard,
                colorSvg: true,
                onClick: () async {
                  final data = await TextHelper.getClipboardData();

                  //? If this has any merit to itself...
                  if (data?.text != null) nameController.text = data!.text!;
                },
              )
            ],
          ),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Finally, the buttons in question.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // For the negative button.
              Expanded(
                child: StyledTextButton(
                  text: "Dismiss",
                  backgroundColor: ThemeColors.primaryColorLight,
                  textColor: ThemeColors.primaryColor,
                  onClick: () {
                    AppRegistry.nav.pop(null);
                  },
                ),
              ),

              // Some space.
              const SizedBox(width: Dimensions.paddingSizeDefault),

              // For the positive button.
              Expanded(
                child: StyledTextButton(
                  text: "Finish",
                  onClick: () async {
                    // Do the actual updating inside of here.
                    final name = nameController.text;

                    // This cannot be empty...
                    if (name.isEmpty) {
                      nameStateNotifier.value = TextFieldState.error;
                      return;
                    }

                    // This is fine.
                    nameStateNotifier.value = TextFieldState.normal;
                    AppRegistry.nav.pop("${directory.path}/$name");
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      false,
    );

    //? If this was cancelled...
    if (result == null) {
      ModalHelper.showErrorDialog("Cancelled creating the folder");
      return;
    }

    //? Then we obtain the name.
    final name = result.toString();
    final response = await controller.createFolder(name);

    //? Then we do it like this.
    if (response) {
      ModalHelper.showSnackBar("The folder has been created successfully.", false);
    }

    //? Since it failed....
    else {
      ModalHelper.showSnackBar("Failed to create the folder");
    }
  }

  /// Utility function used to create a file in a specific path.
  void _createFile(String root, FilesystemController controller) async {
    // Next, for this one.
    final directory = Directory(root);
    final nameController = TextEditingController();
    final nameStateNotifier = ValueNotifier(TextFieldState.normal);
    final nameErrorController = ValueNotifier("The name of the folder cannot be blank.");

    //? Next, do the needful here.
    final result = await ModalHelper.showCustomDialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The title text here.
          Text(
            "Create file",
            textAlign: TextAlign.center,
            style: fontSemiBold.copyWith(
              fontSize: Dimensions.fontSizeOverLarge,
            ),
          ),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Then a divider.
          const Divider(color: ThemeColors.colorTextGray, thickness: 1, height: 0),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          //? First, the name controller.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // First, we have this one...
              Expanded(
                child: StyledTextField(
                  controller: nameController,
                  labelText: "Name",
                  stateNotifier: nameStateNotifier,
                  helperNotifier: nameErrorController,
                ),
              ),

              // Some space.
              const SizedBox(width: Dimensions.paddingSizeDefault),

              // Finally, the paste button.
              StyledTextButton(
                text: "Paste",
                svg: AppIcons.clipboard,
                colorSvg: true,
                onClick: () async {
                  final data = await TextHelper.getClipboardData();

                  //? If this has any merit to itself...
                  if (data?.text != null) nameController.text = data!.text!;
                },
              )
            ],
          ),

          // Next, some negligible space.
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Finally, the buttons in question.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // For the negative button.
              Expanded(
                child: StyledTextButton(
                  text: "Dismiss",
                  backgroundColor: ThemeColors.primaryColorLight,
                  textColor: ThemeColors.primaryColor,
                  onClick: () {
                    AppRegistry.nav.pop(null);
                  },
                ),
              ),

              // Some space.
              const SizedBox(width: Dimensions.paddingSizeDefault),

              // For the positive button.
              Expanded(
                child: StyledTextButton(
                  text: "Finish",
                  onClick: () async {
                    // Do the actual updating inside of here.
                    final name = nameController.text;

                    // This cannot be empty...
                    if (name.isEmpty) {
                      nameStateNotifier.value = TextFieldState.error;
                      return;
                    }

                    // This is fine.
                    nameStateNotifier.value = TextFieldState.normal;
                    AppRegistry.nav.pop("${directory.path}/$name");
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      false,
    );

    //? If this was cancelled...
    if (result == null) {
      ModalHelper.showErrorDialog("Cancelled creating the file");
      return;
    }

    //? Then we obtain the name.
    final name = result.toString();
    final response = await controller.createFile(name);

    //? Then we do it like this.
    if (response) {
      ModalHelper.showSnackBar("The file has been created successfully.", false);
    }

    //? Since it failed....
    else {
      ModalHelper.showSnackBar("Failed to create the file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleStateSubscriberWidget<FilesystemController, FilesystemModel>(
      builder: (controller, filesystem) {
        return FutureSubscriber(
          future: controller.doesDriveDirectoryExist,
          suspenseBuilder: (context) {
            return const SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //? This is fine.
                  Text(
                    "Loading...",
                    style: fontRegular,
                  ),

                  // Some space.
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  //? This is fine then
                  CircularProgressIndicator(
                    color: ThemeColors.primaryColor,
                  ),
                ],
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => UnknownErrorScreen(
            error: error,
            stackTrace: stackTrace,
          ),
          builder: (context, exists) {
            //? Since this does not exist... return a button that would do the
            //? needful here.
            if (exists == false) {
              return UnknownErrorScreen(
                error: "This drive directory does not exist",
                stackTrace: null,
                child: IntrinsicWidth(
                  child: StyledTextButton(
                    text: "Create drive directory",
                    onClick: controller.createDriveDirectory,
                    endSvg: AppIcons.folderAdd,
                    colorSvg: true,
                    horizontalPadding: Dimensions.paddingSize4XL,
                    backgroundColor: ThemeColors.primaryColor,
                  ),
                ),
              );
            }

            //? Since the file exists...
            return StreamSubscriber(
              stream: controller.filesystemWatcher,
              onEmit: (event) {
                if (event != null) AppRegistry.debugLog(event, "Drive.Sync");
              },
              suspenseBuilder: (context) {
                return const SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //? This is fine.
                      Text(
                        "Loading...",
                        style: fontRegular,
                      ),

                      // Some space.
                      SizedBox(height: Dimensions.paddingSizeSmall),

                      //? This is fine then
                      CircularProgressIndicator(
                        color: ThemeColors.primaryColor,
                      ),
                    ],
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => UnknownErrorScreen(
                error: error,
                stackTrace: stackTrace,
              ),
              builder: (context, exists) {
                final focused = controller.workingDirectoryView;

                //? This is fine now.
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? For the buttons to create entries on the top.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? First, the button that forces to sync this directory
                        //? right now.
                        StyledTextButton(
                          text: "Sync folder",
                          onClick: () async {},
                          endSvg: AppIcons.folderUp,
                          colorSvg: true,
                          textColor: Colors.black,
                          backgroundColor: ThemeColors.primaryColorLight,
                        ),

                        // Some space.
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        //? Second, the button that forces to sync the entire
                        //? drive folder right now.
                        StyledTextButton(
                          text: "Sync drive",
                          onClick: () async {},
                          endSvg: AppIcons.stateSyncing,
                          colorSvg: true,
                          backgroundColor: ThemeColors.primaryColor,
                        ),

                        // Some space.
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        //? Third, the button that creates a new folder
                        StyledTextButton(
                          text: "New folder",
                          onClick: () => _createFolder(controller.currentPath, controller),
                          endSvg: AppIcons.folderAdd,
                          colorSvg: true,
                          backgroundColor: ThemeColors.primaryColor,
                        ),

                        // Some space.
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        //? Fourth, the button that creates a new file
                        StyledTextButton(
                          text: "New file",
                          onClick: () => _createFile(controller.currentPath, controller),
                          endSvg: AppIcons.plus,
                          colorSvg: true,
                          backgroundColor: ThemeColors.primaryColor,
                        ),
                      ],
                    ),

                    // Some space.
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    //? We say there is nothing to show yet.
                    if (focused.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //? The error icon
                              SvgPicture.asset(
                                AppIcons.folder,
                                height: 100,
                                color: ThemeColors.colorTextGray,
                              ),

                              // Next, some negligible space.
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              // Next, the subtitle of this dialog.
                              Text(
                                "This directory is empty",
                                textAlign: TextAlign.center,
                                style: fontSemiBold.copyWith(
                                  fontSize: Dimensions.fontSizeExtraLarge,
                                  color: ThemeColors.colorTextGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    //? Since there are contents to show....
                    else
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: focused.length,
                          itemBuilder: (context, index) => Padding(
                            padding: index == 0
                                ? EdgeInsets.zero
                                : const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                            child: DirectoryEntryWidget(
                              data: focused[index],
                            ),
                          ),
                        ),
                      )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
