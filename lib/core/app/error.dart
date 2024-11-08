import 'package:flutter/material.dart';

/// A widget that just diplays an error message. We use the same one that the
/// framework uses in debug mode. At least, for now.
class ErrorTraceWidget extends StatelessWidget {
  final dynamic error;
  const ErrorTraceWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(error);
  }
}
