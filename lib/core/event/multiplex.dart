import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/app/error.dart';
import 'package:msbm_assessment_test/core/base.dart';

/// The [EventSubscriberWidget] takes a list of strings where each one must correspond
/// to the name of an event. It is worth noting that these events for not need
/// to be declared in any way, it's just passing a string. It's not that deep.
/// For this reason, it is advised that these event names are kept as named
/// constants so that the wrong event name is not accidentally written when
/// triggering an event or listening to an event. When any even is triggered
/// matching any of the names this widget is listening for  is fired, the widget
/// would be rebuilt.
///
/// The way this works is kind of like the way events work in the browser. Any
/// event is identified by a name and each event can have multiple listeners
/// subscribed to it. When any part of the app triggers an event, all the
/// listeners would be notified. Exactly like the  state subscription driven
/// state management solution, every time a listener is created for an event, a
/// corresponding ID is generated and given to the caller and without that ID,
/// the caller would not be able to remove this event listener so cleanup would
/// become a painful impossibility.
///
/// The reason there is a Generic Type parameter here is exactly that this
/// construct should only be implemented when you need to listen for multiple
/// events that would give results of the same type probably after doing different
/// things relevant to a single context.
class EventSubscriberWidget<T> extends StatefulWidget {
  /// The list of all events identifier by their names which are allowed to
  /// rebuild this event subscriber. It is worth noting that this widget would
  /// only be rebuilt when an event here is triggered.
  final List<String> events;

  /// A callback that is used to rebuild this widget when any of the events it
  ///  is listening is triggered.
  final Widget Function(
    BuildContext context,
    int redraws,
    String? event,
    T? data,
  ) builder;

  // This is fine.
  const EventSubscriberWidget({
    super.key,
    required this.events,
    required this.builder,
  });

  @override
  State<EventSubscriberWidget> createState() => _EventSubscriberWidgetState<T>();
}

class _EventSubscriberWidgetState<T> extends State<EventSubscriberWidget<T>> {
  final Map<String, String> _listeners = {};
  String? _lastEvent;
  T? _lastData;
  int redraws = -1;

  void _updateSelf(String event, dynamic data) {
    //? Let's invalidate the body of this widget if it needs rebuilding.
    if (mounted) {
      setState(() {
        _lastEvent = event;
        _lastData = data;
        redraws += 1;
      });
    }
  }

  /// A helper function used to create all the event listeners relevant to this
  /// event subscriber widget.
  void _createListeners() {
    //? For each event in the events repository.
    for (final event in widget.events) {
      //? Detect duplicate key additions and do nothing when they happen.
      if (_listeners.containsKey(event)) {
        continue;
      }

      //? Add a new listener whose job is simply to rebuild this
      _listeners[event] = AppRegistry.addEventListener(event, _updateSelf);
    }
  }

  /// A helper function used to
  void _removeListeners() {
    //? For each event listener in our list of event keys...
    for (final event in _listeners.keys) {
      // Remove the listener bound to this event for this subscriber widget.
      AppRegistry.removeEventListener(event, _listeners[event]!);
    }

    // Empty this out.
    _listeners.clear();
  }

  @override
  void initState() {
    super.initState();

    // Create the listeners first.
    _createListeners();
  }

  @override
  void dispose() {
    super.dispose();

    // Remove all event listeners.
    _removeListeners();
    _lastEvent = null;
    _lastData = null;
  }

  @override
  Widget build(BuildContext context) {
    // This is another way to do it.
    try {
      return widget.builder(context, redraws, _lastEvent, _lastData);
    } catch (e) {
      if (kDebugMode) return ErrorTraceWidget(error: e);
    }

    // Then return this here.
    return const SizedBox();
  }
}
