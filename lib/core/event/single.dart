import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/app/error.dart';
import 'package:msbm_assessment_test/core/base.dart';

/// The [SingleEventSubscriberWidget] takes a single string which must correspond
/// to the name of an event. It is worth noting that this event do not need
/// to be declared in any way, it's just passing a string. It's not that deep.
/// For this reason, it is advised that these event names are kept as named
/// constants so that the wrong event name is not accidentally written when
/// triggering an event or listening to an event. When any even is triggered
/// matching the name of this event, it would rebuild this widget.
///
/// The way this works is kind of like the way events work in the browser. Any
/// event is identified by a name and each event can have multiple listeners
/// subscribed to it. When any part of the app triggers an event, all the
/// listeners would be notified. Exactly like the  state subscription driven
/// state management solution, every time a listener is created for an event, a
/// corresponding ID is generated and given to the caller and without that ID,
/// the caller would not be able to remove this event listener so cleanup would
/// become a painful impossibility.
class SingleEventSubscriberWidget<T> extends StatefulWidget {
  /// The identifier of the event that this subscriber would be listening to.
  final String event;

  /// A callback that is used to rebuild this widget when the event it is
  /// listening to is triggered.
  final Widget Function(
    /// The context it is being drawn in.
    BuildContext context,

    /// The number of times this Widget has been redrawn.
    int redraws,

    /// The data passed when this builder is invoked on behalf of the state
    /// management logic.
    T? data,
  ) builder;

  const SingleEventSubscriberWidget({
    super.key,
    required this.event,
    required this.builder,
  });

  @override
  State<SingleEventSubscriberWidget> createState() => _SingleEventSubscriberWidgetState<T>();
}

class _SingleEventSubscriberWidgetState<T> extends State<SingleEventSubscriberWidget<T>> {
  String? listener;
  T? _lastData;
  int redraws = 0;

  void _updateSelf(String event, dynamic data) {
    //? Let's invalidate the body of this widget if it needs rebuilding.
    if (mounted) {
      setState(() {
        _lastData = data;
        redraws += 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Listen for the event in question.
    listener = AppRegistry.addEventListener(widget.event, _updateSelf);
  }

  @override
  void didUpdateWidget(covariant SingleEventSubscriberWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    //? Remove the event listener.
    if (listener != null) {
      AppRegistry.removeEventListener(widget.event, listener!);
    }

    // This is fine.
    _lastData = null;
    listener = null;
  }

  @override
  Widget build(BuildContext context) {
    // This is another way to do it.
    try {
      return widget.builder(context, redraws, _lastData);
    } catch (e) {
      if (kDebugMode) return ErrorTraceWidget(error: e);
    }

    // Then return this here.
    return const SizedBox();
  }
}
