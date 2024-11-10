import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msbm_assessment_test/core/app/logger.dart';
import 'package:msbm_assessment_test/core/task/concurrency.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/helper/time.dart';
import 'package:msbm_assessment_test/widgets/themed/buttons.dart';
import 'package:uuid/uuid.dart';

int _registryCount = 0;

/// A type that denotes an event listener. Typically, you should use this
/// whenever you are making a new event listener.
typedef EventNotificationListener = FutureOr<void> Function(String event, dynamic data);

/// A type that denotes a callback made in the background to "refresh" the state
/// of the app. Does not necessarily need to be set before we know we are doing
/// things right.
typedef StateUpdateTask = FutureOr<void> Function();

class _EntryStructure {
  dynamic value;
  bool initialized;
  dynamic Function()? initializer;

  _EntryStructure(this.value, this.initialized, [this.initializer]);
}

/// A class that represents a kind of storage where we keep all singletons
class RuntimeRegistry {
  TaskScheduler? _scheduler;
  Duration? _stateUpdateTimer;
  LoggerUtility? _logger;
  int _stateUpdateCount = 0;
  bool _updating = false;
  bool _forceLogs = false;
  Timer? _stateUpdateCycle;
  Map<String, List<String>>? _navigatorData;
  Widget Function(BuildContext context, String path)? _routeHandler;
  final List<StateUpdateTask> _updateTasks = [];
  final _singletons = <Type, _EntryStructure>{};
  String? _currentRoute;

  /// The list of all event listeners that for every event in this application.
  /// This should be an exhaustive list of all event listeners for each event.
  final Map<String, Map<String, EventNotificationListener>> _eventListeners = {};

  /// Retrieves the exact number of times the state update mechanism has been
  /// triggered. This does not correspond to how many times individual controllers
  /// have built their state, do not mix them up. This just counts how many times
  /// the [StateUpdateTask] registered here have been invoked.
  int get stateUpdateCount => _stateUpdateCount;

  /// The current context in this application in the application. This is kind
  /// of useful for the application to use.
  BuildContext? get context => navigatorKey.currentContext;

  /// The current route we are navigating through in our mobile app.
  String? get currentRoute => _currentRoute;

  /// The navigator key of this runtime registry. You need to bind this to the
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// The navigator that this is currently bound to.
  NavigatorState get nav => navigatorKey.currentState!;

  /// This is used to retrieve the extra information that was passed to the
  /// navigator when it was moving between states.
  Map<String, List<String>>? get navigatorData => _navigatorData;

  /// This is fine.
  RuntimeRegistry() {
    _registryCount += 1;

    if (_registryCount > 1) {
      throw Exception(
          "Expected to find a single instance of a register in an application but found $_registryCount spawned instances.");
    }
  }

  /// This function must be called exactly once when before is started up and
  /// before the AppRegistry is used even once.
  Future<void> initialize({
    required FutureOr<void> Function(String) onLoggerFull,
    required Widget Function(BuildContext, String) routeHandler,
    Duration stateUpdateDuration = const Duration(seconds: 20),
    bool forceLogs = false,
  }) async {
    _scheduler = await TaskScheduler.init();
    _logger = LoggerUtility(flush: onLoggerFull);
    _routeHandler = routeHandler;
    _stateUpdateTimer = stateUpdateDuration;
    _forceLogs = forceLogs;
  }

  /// Adds a new [StateUpdateTask] to this [RuntimeRegistry]'s list of tasks
  /// required to maintain its state. Unlike all the other event listeners, this
  /// one DOES NOT issue an ID that can later on be used to remove the corresponding
  /// listener. Meaning, when you add it, it stays added.
  ///
  /// However, you can remove ALL updated tasks using the [removeAllUpdateTasks]
  /// method. As a note, although it goes without saying, it would only remove
  /// all the tasks and not help you with anything like "putting them back."
  void addUpdateTask(StateUpdateTask task) {
    _updateTasks.add(task);
  }

  /// Until this function is called the [StateUpdateTask] that were registered
  /// to this [RuntimeRegistry] would never be invoked. This is your way of
  /// saying "it's the right time to kickstart updating state in the background."
  void useUpdateTasks() {
    // Only say this when this is not some mistake.
    if (_stateUpdateCycle == null) {
      AppRegistry.debugLog("Started running all update related tasks.", "State.Update");
    }

    // Every period of time in this duration, I want you to change this.
    _stateUpdateCycle ??= Timer.periodic(
      _stateUpdateTimer!,
      (count) async {
        // Stop if this is updating.
        if (_updating) {
          return;
        }

        // Lock this one.
        _updating = true;

        // This is fine.
        final start = DateTime.now();

        // Do this first.
        debugLog(
          "Started update task #${_stateUpdateCount + 1} at ${DateTimeHelper.getFullTimestamp(start)}",
          "State.Update",
        );

        // This is fine then.
        try {
          for (final task in _updateTasks) {
            await task();
          }
        }

        // Catch any errors.
        catch (e) {
          AppRegistry.debugLog(e, "State.Update");
        }

        //? We've done all of this one more time.
        _stateUpdateCount += 1;

        // Do this.
        AppRegistry.debugLog(
          "State update task #${AppRegistry.stateUpdateCount} finished in ${DateTime.now().difference(start).abs().inMilliseconds}ms",
          "State.Update",
        );

        //? This is fine.
        _updating = false;
      },
    );
  }

  /// The function name does what it says. It removes all update tasks that are
  /// lined up to run periodically. Although this goes without saying, this would
  /// also reset your state update counter.
  void removeAllUpdateTasks() {
    AppRegistry.debugLog("Removed all update related tasks and reset the update counter.", "State.Update");
    _updateTasks.clear();
    _stateUpdateCount = 0;
  }

  /// The function used to cancel the currently running update tasks. This is used
  /// to make sure that, when necessary, nothing unnecessary is happening.
  void stopUpdateTasks() {
    AppRegistry.debugLog("Stopped running all update related tasks", "State.Update");
    _stateUpdateCycle?.cancel();
    _stateUpdateCycle = null;
  }

  /// This is a function that is used to initialize a singleton instance.
  void register<T>(T value) {
    final cached = _singletons[value.runtimeType];

    //? If we have cached data
    if (cached != null) {
      throw Exception("Attempted to register an initializer for a singleton that has already been initialized.");
    }

    //? If there is no cached data.
    _singletons[value.runtimeType] = _EntryStructure(value, true);

    // Log this when the time comes.
    debugLog("Registered the $T singleton and gave it the value #${value.hashCode}", "App.Registry");
  }

  /// A function used to lazily initialize a singleton in this registry. This
  /// uses the builder to create the singleton only when it is needed.
  void lazyRegister<T>(T Function() builder) {
    // Put this in here.
    final cached = _singletons[(T)];

    //? If we have cached data
    if (cached != null) {
      throw Exception("Attempted to register an initializer for a singleton that has already been initialized.");
    }

    //? If there is no cached data.
    _singletons[(T)] = _EntryStructure(null, false, builder);

    // Log this too.
    debugLog("Registered the $T singleton lazily with the builder ${builder.hashCode}", "App.Registry");
  }

  /// A function used to identify a singleton in our registry utilizing its
  /// type.
  T find<T>() {
    // This is fair enough.
    final retrieve = _singletons[(T)];

    //? If this is null
    if (retrieve == null) {
      throw Exception("Attempted to lookup a singleton that has not been initialized ${(T)} and $retrieve");
    }

    //? If this was initialized lazily...
    if (retrieve.initialized == false) {
      retrieve.value = retrieve.initializer!();
      retrieve.initialized = true; // Remember to say it is now initialized.

      // Log the initialization.
      debugLog(
        "Lazily initialized $T singleton with the value #${retrieve.value.hashCode} and builder #${retrieve.initializer!.hashCode}",
        "App.Registry",
      );
    }

    //* Return what we have cached.
    return retrieve.value;
  }

  /// This is a function used to add an event listener to this app registry that
  /// listens for a specific event.
  String addEventListener(String event, EventNotificationListener listener) {
    //? First, check if this contains a mapping for this event.
    //? if it does not, create a new mapping for use
    if (!_eventListeners.containsKey(event)) {
      _eventListeners[event] = {};
    }

    //? This is fine too...
    final key = const Uuid().v1();

    //? Now, add the listener.
    _eventListeners[event]![key] = listener;

    /// This is fine three.
    return key;
  }

  /// This is a function used to remove a given event listener from the app
  /// registry for a specific event using its event listener ID. This listenerId
  /// must be a string that the addEventListener function created when the
  /// identified event listener was being created.
  bool removeEventListener(String event, String listenerId) {
    return _eventListeners[event]?.remove(listenerId) != null;
  }

  /// This is a function used to send an event to all event listeners of a given
  /// notification. An optional parameter data may be passed to the dispatched
  /// notification useful for sending additional information that may be a result
  /// of an action that resulted in the triggering of this event.
  Future<void> notify(String event, [dynamic data]) async {
    final subscribers = _eventListeners[event];

    //? This is a fine way to do things in life.
    for (final listener in (subscribers?.values ?? const Iterable.empty())) {
      await listener(event, data);
    }
  }

  /// Helper function used to schedule a task so that we can schedule a task that
  /// should run to completion so that we can use and obtain relevant results
  /// from the said task.
  Future<T> scheduleTask<T>(Task<T> task) {
    if (_scheduler == null) {
      task.onError(Exception("The app registry was not initialized at app startup."));
    }

    // Just run the task.
    return _scheduler!.run(task);
  }

  /// A helper function used to log the something to the logger utility bound to
  /// this app registry.
  void log(String tag, String message) {
    if (_logger == null) {
      throw Exception("The app registry was not initialized at app startup.");
    }

    _logger!.log(tag, message);
  }

  /// The mediator function used to react to route changes when the app navigates
  /// from one screen to another. For all the functionality in the app to work
  /// properly, it is mandatory to use this function when building a MaterialApp.
  Route<dynamic> onRouteGenerated(RouteSettings settings) {
    // Parse and retrieve the relevant information from the route passed to the
    // navigator.
    final uri = Uri.parse(settings.name!);
    final data = uri.queryParametersAll;

    //? If the route handler has not been created yet.
    if (_routeHandler == null) {
      throw Exception("The app registry was not initialized at app startup.");
    }

    //? If this is debug mode.
    AppRegistry.debugLog("AppRegistry.Navigator: Going to ${uri.path}");
    AppRegistry.debugLog("AppRegistry.NavigatorData: $data");

    // Set the right navigator data.
    _navigatorData = data;
    _currentRoute = uri.path;

    //? Now, it is time to switch things up.
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _routeHandler!(context, uri.path);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  /// A utility function used to show a snackbar in a given context. It does not
  /// really do much internally. It just acts as a relay to the [ScaffoldMessenger]
  /// of the context to show the snackbar in question.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar({
    required String message,
    required Color backgroundColor,
    required String icon,
    Color textColor = Colors.white,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 7),
  }) {
    // The size of this screen.
    final size = MediaQuery.of(context!).size;

    // Build the snackbar and deploy it.
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        elevation: 0,
        margin: EdgeInsets.only(
          right: size.width * 0.70,
          left: Dimensions.paddingSizeDefault,
          bottom: Dimensions.paddingSizeDefault,
        ),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        backgroundColor: backgroundColor,
        showCloseIcon: true,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // This is fine.
            SvgPicture.asset(
              icon,
              color: textColor,
              height: Dimensions.fontSizeLarge,
            ),

            // Some space,
            const SizedBox(width: Dimensions.paddingSizeSmall),

            // For the text here.
            Expanded(
              child: Text(
                message,
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                style: fontRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmaller,
                  color: textColor,
                ),
              ),
            ),

            //? If this is there...
            if (action != null)
              const SizedBox(
                width: Dimensions.paddingSizeSmall,
              ),

            //? If this is there...
            if (action != null)
              StyledTextButton(
                text: action.label,
                onClick: action.onPressed,
                fontSize: Dimensions.fontSizeSmall,
                backgroundColor: action.backgroundColor ?? textColor,
                textColor: action.textColor ?? backgroundColor,
                verticalPadding: Dimensions.paddingSizeSomewhatSmall,
                horizontalPadding: Dimensions.paddingSizeSomewhatSmall,
              ),

            // If this is there...
            if (action != null)
              const SizedBox(
                width: Dimensions.paddingSizeDefault,
              ),
          ],
        ),
      ),
    );
  }

  /// A utility function used to log a message to the console. A good thing to
  /// note about this is that it ONLY logs when the app is in debug mode. To avoid
  /// exposing sensitive information in production environments.
  void debugLog(dynamic message, [String namespace = "AppRegistry.Log"]) {
    if (_forceLogs || kDebugMode) {
      debugPrint("[$namespace]: ${message.toString()}");
    }
  }

  /// A utility function used to log stack information to the console. A good
  /// thing to think about is that this would ONLY log when the app is running
  /// in debug mode.
  void debugLogStack({
    StackTrace? stackTrace,
    String namespace = "AppRegistry.Log",
  }) {
    if (_forceLogs || kDebugMode) {
      debugPrintStack(stackTrace: stackTrace, label: "[$namespace]: ");
    }
  }
}

/// This is the registry used for this app during its runtime and lifecycle. It
/// is worth noting that this should be the ONLY utilized throughout the application.
/// Attempting to construct another RuntimeRegistry would crash the app.
// ignore: non_constant_identifier_names
final AppRegistry = RuntimeRegistry();
