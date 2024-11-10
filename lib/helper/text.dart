import 'package:flutter/services.dart';

class TextHelper {
  TextHelper._();

  static bool isEmail(String s) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(s);
  }

  static bool isPhoneNumber(String s) {
    //? If this is out of range for the expected cases.
    if (s.length > 16 || s.length < 9) {
      return false;
    }

    //? Now, we can check it to confirm.
    return RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(s);
  }

  static bool isWebsocketAddress(String s) {
    return s.startsWith("ws://") || s.startsWith("wss://");
  }

  static bool isNumber(String s) {
    return RegExp(r'[-+]?([0-9]*\. [0-9]+|[0-9]+)').hasMatch(s);
  }

  static bool isUuid(String s) {
    return RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$')
        .hasMatch(s);
  }

  static Future<void> copyToClipboard(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  static Future<ClipboardData?> getClipboardData([String format = "text/plain"]) {
    return Clipboard.getData(format);
  }
}
