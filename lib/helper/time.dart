import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class DurationNotifier extends ValueNotifier<String> {
  DurationNotifier(super.value);
}

class DateTimeHelper {
  DateTimeHelper._();

  static bool isLeapYear(int year) {
    return year % 4 == 0 && year % 100 != 0;
  }

  static int getNumberOfDaysInMonth(int month, int year) {
    return switch (month) {
      DateTime.february => isLeapYear(year) ? 29 : 28,
      DateTime.september || DateTime.april || DateTime.june || DateTime.november => 30,
      _ => 31,
    };
  }

  static String getFullTimestamp(DateTime timestamp) {
    return DateFormat("dd MMM, yyyy | hh:mm a").format(timestamp.toLocal());
  }

  static String getDailyTimestamp(DateTime timestamp) {
    return DateFormat("dd MMM, yyyy").format(timestamp.toLocal());
  }

  static String getMonthlyTimestamp(DateTime timestamp) {
    return DateFormat("MMM, yyyy").format(timestamp.toLocal());
  }

  static String getYearlyTimestamp(DateTime timestamp) {
    return DateFormat("yyyy").format(timestamp.toLocal());
  }

  static String getWeekday(DateTime timestamp) {
    return DateFormat("EEEE").format(timestamp.toLocal());
  }

  static DateTime parseDate(String timestamp) {
    return DateTime.parse(timestamp).toLocal();
  }

  static DateTime getLocalTime(String time) {
    return DateTime.parse(time).toLocal();
  }

  static String convertDurationToTimestamp(Duration duration) {
    final hh = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}
