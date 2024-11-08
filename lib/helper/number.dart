import 'package:intl/intl.dart';

class NumberHelper {
  NumberHelper._();

  static String getRawPrice(double amount) {
    return NumberFormat.currency(symbol: "").format(amount);
  }

  static String shorthandForm(double number) {
    return NumberFormat.compact().format(number);
  }
}
