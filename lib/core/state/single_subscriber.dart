import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/app/error.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/state/state.dart';

/// A utility type used to help construct a builder appropriately.
typedef SingleSubscriberBuilder<T extends StateController, TData extends ObjectState> = Widget Function(
    T controller, TData? state);

/// A Widget that represents any widget which would typically subscribe to
/// a single StateController instances.Every time the state of this controller
/// this Widget is subscribed to is updated, the Widget is triggered to be
/// rebuilt.
///
/// The [SingleStateSubscriberWidget] takes an instance of the [StateController]
/// type. Each widget instance would listen to changes in the state of this
/// controller it subscribes to. Meaning when the controllers [StateController.invalidate]
/// or [StateController.update] to mutate their state, the widget would get
/// rebuilt using [SingleStateSubscriberWidget.builder].
class SingleStateSubscriberWidget<T extends StateController, TData extends ObjectState> extends StatefulWidget {
  /// A callback that is used to rebuild this widget when [controller] has
  /// invalidated or updated its state.
  final SingleSubscriberBuilder<T, TData> builder;

  /// An optional callback that this widget can use to handle the event where
  /// the app is put in the background.
  final void Function()? onPause;

  /// An optional callback that can be used to handle the event where this widget
  /// is resumed from the background
  final void Function()? onResume;

  /// An optional callback that is used to handle the event where this application
  /// is no longer active while running in the foreground.
  final void Function()? onDeactivate;

  /// An optional callback that can be used to handle the event where this widget
  /// is disposed. Well, at least a state of it is disposed.
  final void Function()? onDispose;

  const SingleStateSubscriberWidget({
    super.key,
    required this.builder,
    this.onPause,
    this.onResume,
    this.onDeactivate,
    this.onDispose,
  });

  @override
  State createState() => _SingleStateSubscriberWidgetState<T, TData>();

  // @override
  // void didChangeAccessibilityFeatures() {
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused && onPause != null) {
  //     onPause!();
  //   }

  //   if (state == AppLifecycleState.resumed && onResume != null) {
  //     onResume!();
  //   }

  //   if (state == AppLifecycleState.inactive && onDeactivate != null) {
  //     onDeactivate!();
  //   }

  //   // Then do this.
  //   super.didChangeAppLifecycleState(state);
  // }

  // @override
  // void didChangeLocales(List<Locale>? locales) {
  //   super.didChangeLocales(locales);
  // }

  // @override
  // void didChangeMetrics() {}

  // @override
  // void didChangePlatformBrightness() {}

  // @override
  // void didChangeTextScaleFactor() {}

  // @override
  // void didHaveMemoryPressure() {}

  // @override
  // Future<bool> didPopRoute() async {
  //   return true;
  // }

  // @override
  // Future<bool> didPushRoute(String route) async {
  //   return true;
  // }

  // @override
  // Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
  //   return true;
  // }

  // @override
  // Future<AppExitResponse> didRequestAppExit() async {
  //   return AppExitResponse.exit;
  // }
}

class _SingleStateSubscriberWidgetState<T extends StateController, TData extends ObjectState>
    extends State<SingleStateSubscriberWidget<T, TData>> {
  String? listener;
  TData? state = AppRegistry.find<T>().currentState as TData?;
  T get controller => AppRegistry.find<T>();

  //? Delete this.
  void _redraw(dynamic oldState, dynamic newState) {
    try {
      setState(() {
        state = controller.currentState as TData?;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();

    // First, we set the right state.
    state = controller.currentState as TData?;

    // Next, listen to this controller and then bind the listener.
    listener = controller.addListener(_redraw);
  }

  @override
  void didUpdateWidget(covariant SingleStateSubscriberWidget<T, TData> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Remove the listener.
    controller.removeListener(listener!);
    state = null;
    listener = null;
    widget.onDispose?.call();

    // Then call the dispose function afterwards.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This is a valid binding observer.
    // WidgetsBinding.instance.addObserver(widget);

    // This is another way to do it.
    try {
      return widget.builder(controller, state);
    } catch (e) {
      if (kDebugMode) return ErrorTraceWidget(error: e);
    }

    // Then return this here.
    return const SizedBox();
  }
}
