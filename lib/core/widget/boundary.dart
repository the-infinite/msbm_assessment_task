import 'dart:async';

import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/base.dart';

/// The controller used to affect the state of the top-level navigation handler.
class InterceptorController {
  bool _shouldBlock = false;

  /// A utility getter that returns true if the top-level navigation handler is
  /// not allowed to pop.
  bool get shouldBlock => _shouldBlock;

  /// A utility function used to block the top-level navigation handler. It is
  /// worth noting that this would make it impossible for the top level navigation
  /// handler to actually work without calling release.
  void block() {
    _shouldBlock = true;
  }

  /// This is used to tell the top-level navigation handler that it can now start
  /// popping again.
  void release() {
    _shouldBlock = false;
  }
}

/// A utility widget used to prevent the underlying top level back navigation
/// gesture from popping the state of the navigator stack. It only lasts until
/// this widget is no longer is in view.
class InterceptorBoundary extends StatefulWidget {
  final Widget child;
  final FutureOr<bool> Function()? onPopInvoked;
  final bool canPop;

  // Construct.
  const InterceptorBoundary({
    super.key,
    required this.child,
    this.onPopInvoked,
    this.canPop = true,
  });

  @override
  State<InterceptorBoundary> createState() => _InterceptorBoundaryState();
}

class _InterceptorBoundaryState extends State<InterceptorBoundary> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //? If this has already happened, or it should in fact block...
        if (AppRegistry.find<InterceptorController>().shouldBlock) {
          AppRegistry.debugLog(
            "Blocked a re-entrant function call.",
            "Widgets.InterceptorBoundary",
          );

          //? This is fine.
          return false;
        }

        //* Now, block to prevent race conditions.
        AppRegistry.find<InterceptorController>().block();

        //? If this has already happened, or it should in fact block...
        AppRegistry.debugLog(
          "Entered a re-entrant function call.",
          "Widgets.InterceptorBoundary",
        );

        //? This is fine.
        bool result = widget.canPop;

        //? If this is not undefined.
        if (widget.onPopInvoked != null) {
          //? Obtain the result now from the function.
          try {
            result = await widget.onPopInvoked!.call();
          }

          //? Catch any errors that might arise.
          catch (e) {
            AppRegistry.debugLog(e, "Widgets.InterceptorBoundary");
            AppRegistry.debugLogStack(
              stackTrace: (e is Error) ? e.stackTrace ?? StackTrace.current : StackTrace.current,
              namespace: "Widgets.InterceptorBoundary",
            );
          }
        }

        //* Release the lock...
        AppRegistry.find<InterceptorController>().release();

        //* Return this result.
        return result;
      },
      child: widget.child,
    );
  }
}
