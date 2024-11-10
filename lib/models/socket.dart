import 'package:msbm_assessment_test/core/state/state.dart';

class WebSocketCommand extends ObjectState {
  final String command;
  final String modulator;
  final List<String> arguments;

  WebSocketCommand({
    required this.command,
    required this.modulator,
    required this.arguments,
  });

  factory WebSocketCommand.fromStream(String raw) {
    final data = raw.split(" ");

    //? This is fine.
    return WebSocketCommand(
      command: data[0].toString().toLowerCase(),
      modulator: data[1].toString().toLowerCase(),
      arguments: data.skip(2).map((stream) => stream.toString().trim()).toList(),
    );
  }

  @override
  SavedStateData toSavedState() {
    return {
      "command": command,
      "modulator": modulator,
      "arguments": arguments,
    };
  }
}
