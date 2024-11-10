import 'dart:io';

import 'package:msbm_assessment_test/controllers/app.dart';
import 'package:msbm_assessment_test/controllers/filesystem.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:msbm_assessment_test/controllers/settings.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/models/socket.dart';
import 'package:msbm_assessment_test/repositories/socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketController extends StateController<WebSocketCommand, WebSocketRepository> {
  WebSocketChannel? _channel;
  bool _pullingFile = false;
  File? _scratchFile;
  IOSink? _scratchSink;

  /// A controller utility used to retrieve the WebSocket that is actually being
  /// used to communicate with the servers remotely.
  WebSocketChannel get socketChannel => _channel!;

  // Construct.
  WebSocketController({required super.repo}) {
    final settings = AppRegistry.find<SettingsController>().currentState;

    //? If this was defined...
    if (settings?.websocketUrl != null) Future.delayed(const Duration(seconds: 1), getConnection);

    //? This is fine.
    initialize(null);
  }

  /// A controller utility that is used to get the [WebSocketChannel] that is
  /// obtained after we connect to whatever URI that has been configured here.
  Future<void> getConnection() async {
    final settings = AppRegistry.find<SettingsController>().currentState;

    //? Get the websocket channel.
    _channel = await repository.getConnection(settings!.websocketUrl!);

    //! Break here if the channel is null.
    if (_channel == null) return;

    //? This is fine.
    socketChannel.stream.listen(
      (event) async {
        final command = event.toString().trim();
        final result = await handleSocketCommand(command, event);

        //? Check the result that we get when we try to handle this.
        if (!result) {
          AppRegistry.debugLog("Failed to handle the WebSocket command.", "Helpers.WebSocket");
        }

        //? This is fine.
        socketChannel.sink.add("cmd-status $result");
      },
      onDone: () {
        AppRegistry.debugLog("Socket closed", "Helpers.WebSocket");
      },
      onError: (error) {
        AppRegistry.debugLog(error, "Helpers.WebSocket");
      },
    );
  }

  /// A controller utility used to close the [WebSocketChannel].
  Future<void> closeConnection() async {
    _channel?.sink.close(status.normalClosure);
  }

  /// A controller utility used to handle WebSocket commands that are either
  /// emulated or broadcasted from the [WebSocketChannel].
  Future<bool> handleSocketCommand(String event, [dynamic raw]) async {
    //? Save the command.
    AppRegistry.debugLog("Command: $event", "Helpers.WebSocket");

    //? If this has been closed...
    if (_channel?.closeReason != null) return false;

    //? First, obtain the command.
    final command = WebSocketCommand.fromStream(event);
    final app = AppRegistry.find<AppController>();
    final filesystem = AppRegistry.find<FilesystemController>();

    //? This is fine.
    if (_pullingFile && command.command != "pull") {
      _scratchSink!.add(raw);
    }

    //? Then we do the needful.
    switch (command.command) {
      //? For USB related commands...
      case "usb":
        {
          if (command.modulator != "device") break;

          //? If the subcommand is null...
          final subCommand = command.arguments.firstOrNull?.toLowerCase();

          //? If this is the block command.
          if (subCommand == "block") {
            app.setUSBDisabledState();
            await Future.delayed(const Duration(seconds: 2));
            app.setSyncingNoneState();
            return true;
          }

          //? If this
          else if (subCommand == "unblock") {
            app.setUSBEnabledState();
            await Future.delayed(const Duration(seconds: 2));
            app.setSyncingNoneState();
            return true;
          }
        }
        break;

      case "sync":
        {
          if (command.modulator == "now") {
            filesystem.silentSyncChanges();
            return true;
          }
        }
        break;

      case "push":
        {
          if (command.modulator == "folder") {
            // TODO: Add support for forwarding entire folders over the wire.
            return false;
          }

          //? Since this is now for files...
          if (command.modulator == "file") {
            final path = command.arguments.firstOrNull;

            //? Return false.
            if (path == null) return false;

            //? Get the file path.
            final file = File("${filesystem.drivePath}/$path");

            // Await this to finish reading...
            try {
              await socketChannel.sink.addStream(file.openRead());
              socketChannel.sink.add("push eof");
            } catch (e) {
              AppRegistry.debugLog(e, "Helpers.WebSocket");
              return false;
            }

            //? This means we are good.
            return true;
          }

          //? Since this is for the end of a stream.
          if (command.modulator == "eof") {
            _scratchFile = null;
            return true;
          }
        }

        break;

      case "pull":
        {
          if (command.modulator == "folder") {
            return false;
          }

          //? Since this is for files.
          if (command.modulator == "file") {
            final path = command.arguments.firstOrNull;

            //? Return false.
            if (path == null) return false;

            //? Get the file path.
            _scratchFile = File("${filesystem.drivePath}/$path");
            _pullingFile = true;
            _scratchSink = _scratchFile?.openWrite();

            //? This means we are good.
            return true;
          }

          //? If this is the end of stream.
          if (command.modulator == "eof") {
            _scratchFile = null;
            _pullingFile = false;
            await _scratchSink?.close();
            _scratchSink = null;
            return true;
          }
        }
        break;

      case "cmd-status":
        {
          return true;
        }

      default:
        break;
    }

    //? Return.
    return false;
  }
}
