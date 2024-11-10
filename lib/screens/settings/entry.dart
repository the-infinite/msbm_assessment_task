import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/controllers/settings.dart';
import 'package:msbm_assessment_test/controllers/socket.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/state/single_subscriber.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/helper/text.dart';
import 'package:msbm_assessment_test/models/settings.dart';
import 'package:msbm_assessment_test/screens/settings/widget/buttons.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';
import 'package:msbm_assessment_test/widgets/themed/textfield.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static SettingsModel? get _cachedSettings => AppRegistry.find<SettingsController>().currentState;
  final _websocketController = TextEditingController(text: _cachedSettings?.websocketUrl);
  final _websocketStateNotifier = ValueNotifier(TextFieldState.normal);
  final _websocketErrorController = ValueNotifier("This is not a valid WebSocket address.");
  final _emulateWebsocket = ValueNotifier(_cachedSettings?.emulateWebsocket ?? false);

  @override
  void initState() {
    AppRegistry.find<SettingsController>().createDefaultSettings();
    super.initState();
  }

  @override
  void dispose() {
    _websocketController.dispose();
    _websocketStateNotifier.dispose();
    _websocketErrorController.dispose();
    super.dispose();
  }

  /// Utility used to apply all these changes and save them to disk.
  void _applyChanges() async {
    final settings = AppRegistry.find<SettingsController>().currentState;
    final socket = _websocketController.text.trim();
    final emulated = _emulateWebsocket.value;

    //? This is fine.
    _websocketStateNotifier.value = TextFieldState.normal;

    //? If this is not a websocket address...
    if (!TextHelper.isWebsocketAddress(socket)) {
      _websocketStateNotifier.value = TextFieldState.error;
      return;
    }

    //? Next, we update this.
    AppRegistry.find<SettingsController>().cacheSettings(
      settings!.copyWith(
        websocketUrl: socket,
        emulateWebsocket: emulated,
        version: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final size = MediaQuery.sizeOf(context);

    //? This is fine.
    return SingleStateSubscriberWidget<SettingsController, SettingsModel>(
      builder: (controller, settings) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "App Configuration",
              style: fontSemiBold.copyWith(
                fontSize: Dimensions.fontSize2XL,
              ),
            ),

            // Some space.
            const SizedBox(height: Dimensions.paddingSize1XL),

            //? First, the websocket URL controller.
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: StyledTextField(
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.done,
                    labelText: "Remote Websocket URL",
                    controller: _websocketController,
                    stateNotifier: _websocketStateNotifier,
                    helperNotifier: _websocketErrorController,
                  ),
                ),

                // Some space.
                const SizedBox(width: Dimensions.paddingSizeDefault),

                // Finally, the paste button.
                StyledTextButton(
                  text: "Paste",
                  svg: AppIcons.clipboard,
                  colorSvg: true,
                  verticalPadding: Dimensions.paddingSizeSmall,
                  onClick: () async {
                    final data = await TextHelper.getClipboardData();

                    //? If this has any merit to itself...
                    if (data?.text != null) _websocketController.text = data!.text!;
                  },
                ),
              ],
            ),

            // Some space.
            const SizedBox(height: Dimensions.paddingSizeLarge),

            //? Second, the toggle to check if we can emulate WebSockets.
            EmulateWebSocketButton(
              controller: _emulateWebsocket,
            ),

            // Some space.
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),

            //? Next, we create some more content.
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Do nothing but eat a little space.
                const Spacer(),

                // The button.
                SizedBox(
                  width: size.width * 0.15,
                  child: StyledTextButton(
                    text: "Save changes",
                    svg: AppIcons.stateLoaded,
                    colorSvg: true,
                    spaceEvenly: null,
                    onClick: _applyChanges,
                  ),
                ),
              ],
            ),

            //? Now for the buttons that assist with emulating websocket commands
            ValueListenableBuilder(
              valueListenable: _emulateWebsocket,
              builder: (context, isEmulated, _) {
                //? If this is not emulated...
                if (!isEmulated) return const SizedBox();

                //? Get the websocket controller.
                final socket = AppRegistry.find<WebSocketController>();

                //? Since it is emulated.
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Some space.
                    const SizedBox(height: Dimensions.paddingSize3XL),

                    Text(
                      "WebSocket Commands Emulator",
                      style: fontSemiBold.copyWith(
                        fontSize: Dimensions.fontSize2XL,
                      ),
                    ),

                    // Some space.
                    const SizedBox(height: Dimensions.paddingSize1XL),

                    //? This is fine.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.15,
                          child: StyledTextButton(
                            text: "Disable USB Devices",
                            svg: AppIcons.usbDisabled,
                            colorSvg: true,
                            spaceEvenly: null,
                            onClick: () {
                              socket.handleSocketCommand("usb device block");
                            },
                          ),
                        ),

                        // Some space.
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        //? Then enable the blocked USB devices
                        SizedBox(
                          width: size.width * 0.15,
                          child: StyledTextButton(
                            text: "Enable USB Devices",
                            svg: AppIcons.usbEnabled,
                            colorSvg: true,
                            spaceEvenly: null,
                            onClick: () {
                              socket.handleSocketCommand("usb device unblock");
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
