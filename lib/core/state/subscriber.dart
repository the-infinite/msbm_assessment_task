import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/services/predictive_back_event.dart';
import 'package:flutter/widgets.dart';
import 'package:msbm_assessment_test/core/app/error.dart';
import 'package:msbm_assessment_test/core/state/state.dart';

typedef _WBO = WidgetsBindingObserver;

/// A Widget that represents any widget which would typically subscribe to
/// multiple StateController instances. Everytime the state of any controller
/// this Widget is subscribed to is updated, the Widget is triggered to be
/// rebuilt.
///
/// The [StateSubscriberWidget] takes list of with entries of the [StateController]
/// type. Each widget instance would listen to changes in the state of ALL of the
/// controllers it subscribes to. Meaning when any of the controllers rebuild or
/// mutate their state, the widget would get redrawn.
class StateSubscriberWidget extends StatefulWidget implements _WBO {
  /// The list of all state controllers that are allowed to rebuild this state
  /// subscriber widget. It is worth noting that these are ALL allowed to trigger
  /// this widget to rebuild.
  final List<StateController> controllers;

  /// A callback that is used to rebuild this widget when a state controller has
  /// been rebuilt.
  final Widget Function(StateController?, ObjectState?) builder;

  /// An optional callback that this widget can use to handle the event where
  /// the app is put in the background.
  final void Function()? onPause;

  /// An optional callback that can be used to handle the event where this widget
  /// is resumed from the background
  final void Function()? onResume;

  /// An optional callback that is used to handle the event where this application
  /// is no longer active while running in the foreground.
  final void Function()? onDeactivate;

  const StateSubscriberWidget({
    super.key,
    required this.builder,
    required this.controllers,
    this.onPause,
    this.onResume,
    this.onDeactivate,
  });

  @override
  State<StateSubscriberWidget> createState() => _StateSubscriberWidgetState();

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && onPause != null) {
      onPause!();
    }

    if (state == AppLifecycleState.resumed && onResume != null) {
      onResume!();
    }

    if (state == AppLifecycleState.inactive && onDeactivate != null) {
      onDeactivate!();
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() async {
    return true;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    return true;
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    return true;
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    return AppExitResponse.exit;
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) {}

  @override
  void handleCancelBackGesture() {}

  @override
  void handleCommitBackGesture() {}

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    return false;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {}
}

///
class _StateSubscriberWidgetState extends State<StateSubscriberWidget> {
  final Map<Type, String> _listeners = {};
  StateController? _lastController;
  ObjectState? state;

  @override
  void initState() {
    super.initState();

    //? For each state controller that this widget subscribes to...
    for (final controller in widget.controllers) {
      //? Detect duplicate key additions
      if (_listeners.containsKey(controller.runtimeType)) {
        continue;
      }

      //? Then, we bind this to this one.
      _listeners[controller.runtimeType] = controller.addListener(
        (oldState, newState) {
          //? Only perform the update if the state is mounted.
          try {
            setState(() {
              state = newState;
              _lastController = controller;
            });
          } catch (_) {}
        },
      );
    }
  }

  @override
  void didUpdateWidget(covariant StateSubscriberWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    // Stop observing this one.
    WidgetsBinding.instance.removeObserver(widget);

    //? This is fine.
    for (final controller in widget.controllers) {
      controller.removeListener(_listeners[controller.runtimeType]!);
    }

    // Clear this out.
    _listeners.clear();
    _lastController = null;
    state = null;
  }

  @override
  Widget build(BuildContext context) {
    // This is a valid binding observer.
    WidgetsBinding.instance.addObserver(widget);

    // This is another way to do it.
    try {
      return widget.builder(_lastController, state);
    } catch (e) {
      if (kDebugMode) return ErrorTraceWidget(error: e);
    }

    // Then return this here.
    return const SizedBox();
  }
}
