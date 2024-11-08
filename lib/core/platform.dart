import 'dart:io';

class RuntimePlatform {
  /// Is this running in a mobile environment?
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Is this running in a desktop environment?
  static bool get isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  /// Is this running in a web environment?
  static bool get isWeb => const bool.fromEnvironment('dart.library.js_util');
}
