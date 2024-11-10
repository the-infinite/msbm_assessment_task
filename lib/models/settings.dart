import 'package:msbm_assessment_test/core/state/state.dart';

class SettingsModel extends ObjectState {
  final String? websocketUrl;
  final int version;
  final bool emulateWebsocket;

  SettingsModel({
    required this.websocketUrl,
    required this.version,
    required this.emulateWebsocket,
  });

  factory SettingsModel.fromState(SavedStateData data) {
    return SettingsModel(
      websocketUrl: data["socket"],
      version: data["version"],
      emulateWebsocket: data["emulated"],
    );
  }

  SettingsModel copyWith({
    String? websocketUrl,
    int? version,
    bool? emulateWebsocket,
  }) {
    return SettingsModel(
      websocketUrl: websocketUrl ?? this.websocketUrl,
      version: version ?? this.version,
      emulateWebsocket: emulateWebsocket ?? this.emulateWebsocket,
    );
  }

  @override
  SavedStateData toSavedState() {
    return {
      "socket": websocketUrl,
      "version": version,
      "emulated": emulateWebsocket,
    };
  }
}
