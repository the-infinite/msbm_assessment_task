import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/data/repo.dart';
import 'package:uuid/uuid.dart';

typedef SavedStateData = Map<dynamic, dynamic>;
typedef StateListener<T extends ObjectState> = void Function(T? oldState, T? newState);

class BooleanState extends ObjectState {
  bool value = false;
  BooleanState(this.value);

  @override
  BooleanState.fromState(SavedStateData savedState) {
    value = savedState["booleanValue"] ?? false;
  }

  @override
  SavedStateData toSavedState() {
    return {"booleanValue": value};
  }
}

/// A class which represents the state of a controller at any given time. It is
/// worth noting that since any given instance would represent mutable state, it
/// should NEVER contain any final fields. This would result in difficult or
/// otherwise undefined behavior.
abstract class ObjectState {
  ObjectState();

  /// This is a helper function used to serialize an object state as a key-value
  /// store. This is kind of a means to convert the state object to something
  /// that can be readily converted to a method that can be easily serialized
  /// or reused.
  SavedStateData toSavedState();

  /// This is a helper constructor used to build an object state using a cached
  /// version of the saved state. It is particularly handy because half the time
  /// we would want to use this to build a state object using data retrieved
  /// from a stream.
  ObjectState.fromState(SavedStateData savedState);

  // Return this like this.
  @override
  String toString() {
    return toSavedState().toString();
  }
}

/// A class that is used to manage the state of any Widget with "Parcelable" state.
/// Parcelable here is a fancy way of saying we can represent the state of the
/// Widget in any object notation or data description language. Well, right now
/// all that practically matters to us is JSON.
abstract class StateController<TState extends ObjectState, TRepo extends DataRepository> {
  /// How many times this StateController has triggered a repaint.
  int _redraws = -1;

  /// The current state of this controller.
  TState? _state;

  /// The list of all state listeners for this controller. This is useful
  /// because it helps us do things when the state of this controller is
  /// modified
  final Map<String, StateListener> _listeners = {};

  /// The repository this controller gets its data from.
  TRepo? _repo;

  /// This is used to return a count of how many times this controller has been
  /// used to invalidate state. Useful for profiling activity of a single controller.
  int get invalidatedCount => _redraws;

  /// This is  the repository that this controller fetches its data from. It is
  /// worth noting that this should be thought of as the source of data which is
  /// used to maintain the state of this state controller.
  TRepo get repository => _repo!;

  /// This is used to retrieve the information of the current state of this
  /// controller. The state of a controller is usually supposed to be modified
  /// programmatically. Until the state is set inside a controller
  TState? get currentState => _state;

  /// This is used to retrieve the state of
  SavedStateData? get currentSavedState => _state?.toSavedState();

  /// A constructor used to initialize any given state controller with its data
  /// source. The reason the data source is mandatory here and the initial state
  /// is not is that, commonly, you typically might not have any data that
  /// corresponds to the initial state of an application locally and would need
  /// to fetch it remotely. Even if you do have it stored locally, it would be
  /// in some type of persistent cache. In this case, I chose to use [SharedPreferences]
  /// and you can retrieve this shared preferences instance by going to the
  /// [DataRepository.localStorage] field.
  StateController({required TRepo repo}) {
    this._repo = repo;
  }

  /// This is used to bind a listener to this StateController. This returns the
  /// key of this listener which can be used to remove it from this controller
  /// when it is time to clean up later.
  String addListener(StateListener listener) {
    final key = const Uuid().v4();

    // If this is undefined, initialize it.
    _listeners[key] = listener;

    // Return this key.
    return key;
  }

  /// This is used to remove a listener from this state controller. Returns true
  /// if this was successfully removed and false otherwise.
  bool removeListener(String listener) {
    return _listeners.remove(listener) != null;
  }

  /// This is a function that is used to set the initial state of a state
  /// controller. This should ONLY be called once throughout the lifetime of any
  /// state controller.
  void initialize(TState? state) {
    if (_redraws > -1) {
      throw Exception("Attempted to initialize a controller which has already been initialized.");
    }

    // Update the state.
    _redraws += 1;
    _state = state;
  }

  /// This is a function that is used to invoke all the listeners of this
  /// controller to tell them that the state of this controller has been changed
  /// so they can go along their own ways to do what they want.
  void invalidate(TState? newState) {
    //? If this controller has not been initialized.
    if (_redraws == -1) {
      throw Exception("Attempted to invalidate the state of a controller which has not been initialized.");
    }

    // First, get the other states.
    final oldState = _state;
    _state = newState;

    // Now, we iterate on each listener.
    for (var listener in _listeners.values) {
      listener(oldState, newState);
    }

    //? Let's do this.
    _redraws += 1;
    AppRegistry.debugLog("Rebuilt the $runtimeType $invalidatedCount times");
  }

  /// This is a function used to trigger a state update without actually
  /// providing any new state. It is worth noting that you should listen for
  /// this special case when applying this listener.
  void update() {
    //? If this controller has not been initialized.
    if (_redraws == -1) {
      throw Exception("Attempted to update the state of a controller which has not been initialized.");
    }

    // Now, we iterate on each listener.
    for (var listener in _listeners.values) {
      listener(_state, _state);
    }

    // Let's do this.
    _redraws += 1;
    AppRegistry.debugLog("Rebuilt the $runtimeType $invalidatedCount times");
  }

  /// A function that is used to restore the controller from a given state. It
  /// is worth knowing that this implementation does not actually do anything.
  /// If is just supposed to show the parametrics of the function and act as an
  /// illustrative guideline to teach you how to override and impelement it for
  /// other controllers.
  ///
  /// Funny note, I just remembered, yeah? This throws an error if you try to
  /// invoke it so do remember NEVER to invoke the super method.
  Future<void> restoreState([TState? state]) async {
    throw UnimplementedError(
      "If you want to use StateController.restoreState you have to override this default behavior of throwing an error.",
    );
  }

  /// Helper function used to reset the state of this state controller.
  Future<void> resetState() async {}
}
