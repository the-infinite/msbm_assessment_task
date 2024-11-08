import 'dart:async';

/// A utility that logs all of the information to a string buffer. The reason we
/// log to a string buffer and not the console directly is that we want to give
/// the implementation as much room as possible to dump the logs in the place
/// that makes the most sense.
class LoggerUtility {
  /// How long this log should become in characters until the next dump event is
  /// triggered.
  final int dumpThreshold;

  /// The function invoked when the dump threshold is reached. It is kind of
  /// worth noting that this is something fair to have in every sense of the
  /// word.
  final FutureOr<void> Function(String data) flush;

  /// The log information that is ACTUALLY kept here.
  String _log = "";

  // This is quite convenient. To be very honest.
  LoggerUtility({
    this.dumpThreshold = 1000000,
    required this.flush,
  });

  /// A helper function used to log a specific message with a given tag to this
  /// logger utility. This
  void log(String tag, String message) {
    // Append the log in this format...
    _log += '$tag[${DateTime.now().toString()}]: $message\n';

    // If this is longer than we ideally need it to be....
    if (_log.length >= dumpThreshold) {
      flush(_log);

      // Now, clear out the log again.
      _log = "";
    }
  }
}
