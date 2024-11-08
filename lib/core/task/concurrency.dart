import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';

typedef ProcessFn<T> = FutureOr<dynamic> Function(T result);
typedef PostProcessCallback = void Function(dynamic result);

/// A class that represents the model of a task that that is executed on the task
/// scheduler internally.
class Task<T> {
  /// The function that ACTUALLY represents the computation required to execute
  /// this task. It is worth noting that this may or may not be exactly the most
  /// desirable way to do something.
  final FutureOr<T> Function() computation;

  /// A callback that is made when we encounter an error here.
  final T Function(dynamic error, [StackTrace? stackTrace]) onError;

  /// A callback that is executed to completion with the results of the task's
  /// computation. This is used to obtain final results relevant to the task as
  /// a whole in the unbelievable common cases where there are multiple steps
  /// required to complete any given task and each interweaved step — or at least
  /// the first step — might fail and we are fine with that.
  ///
  /// A practical and commonplace example would be fetching data from an offline
  /// or online location and doing a few things with it before using the final
  /// results in the intended manner. To obtain post-processing results from this
  /// secondary computation, you are REQUIRED to add an appropriate callback
  /// using the [Task.weave] function
  final ProcessFn<T>? processFn;

  /// A callback made when the postprocessing is complete, if you include it, or
  /// something like that. Note, this callback would ONLY be made when all the
  /// postprocessing is already complete.
  PostProcessCallback? _onProcess;

  /// When the result of any operation is generated after it is finished, it
  /// would be stored here so that we can use it.
  final ReceivePort _resultPort = ReceivePort();

  /// A result port used to receive the post processing result.
  final ReceivePort _processPort = ReceivePort();

  /// Create a task with its own computation.
  Task({
    required this.computation,
    required this.onError,
    this.processFn,
  });

  /// Make it something that can be send over the network to the next [Isolate]
  Map<String, dynamic> _toSerializable() {
    final data = <String, dynamic>{};
    data["computation"] = computation;
    data["error"] = onError;
    data["sender"] = _resultPort.sendPort;
    data["processing"] = processFn;
    data["processed"] = _processPort.sendPort;
    return data;
  }

  /// A handy function used to set the post-process callback. Which is essentially
  /// a function that would get called when the processing is complete in order
  /// to wrap up the operation that is being executed. It is worth noting that
  /// this function gets called on the main isolate and not one of the parallel
  /// executors. This is because we want the results to ACTUALLY be useful on to
  /// you when you want to use them.
  Task<T> weave(PostProcessCallback? postProcess) {
    _onProcess = postProcess;
    return this;
  }
}

/// A wrapper class that creates an isolate that would be left running to execute
/// tasks that are brought up over and over again.
class TaskExecutor {
  /// This is the receiver that this task executor uses to run its tasks.
  late final ReceivePort receiver;

  /// This is something that is worth keeping here because it is nice enough to
  /// have it around us.
  late final Stream<dynamic> broadcastReceiver;

  /// This is a nice way to keep this here.
  late final SendPort communicatorSendPort;

  /// This is the isolate that this task executor uses under the hood.
  late final Isolate isolate;

  /// This is your completer index.
  late int completerIndex;

  /// The capability of this task executor after being paused to save power.
  Capability? _capability;

  // And empty shell of a constructor. Kept to conveniently allow us to create
  // naked instances of this class.
  TaskExecutor._();

  /// This creates a new spawn executor that you can wait for to achieve your
  /// results.
  static Future<TaskExecutor> init(int completerIndex, int maxCount) async {
    /// Create the executor here.
    final executor = TaskExecutor._();
    final root = RootIsolateToken.instance!;
    executor.receiver = ReceivePort();
    executor.completerIndex = completerIndex;

    // How much padding to add to this string.
    final padCount = maxCount.toString().length + 5;

    // First, spawn and saved this isolate here.
    executor.isolate = await Isolate.spawn(
      _executorCore,
      (root, executor.receiver.sendPort),
      debugName: "Task.Executor[wrk::${completerIndex.toString().padRight(padCount)}]",
    );

    // Now, create the broadcast receiver and communicator send ports.
    executor.broadcastReceiver = executor.receiver.asBroadcastStream();
    executor.communicatorSendPort = await executor.broadcastReceiver.first;

    // Return the executor we just made.
    return executor;
  }

  /// A helper function used internally to loopback around the isolate here so
  /// that we can initialize the state of the isolate that runs this function
  /// appropriately while also establishing the required two way communication.
  static void _executorCore((RootIsolateToken root, SendPort sendPort) data) async {
    // Fetch this much.
    final root = data.$1;
    final sendPort = data.$2;

    // This is fine then.
    BackgroundIsolateBinaryMessenger.ensureInitialized(root);

    // Get this back.
    final taskReceiver = ReceivePort();
    sendPort.send(taskReceiver.sendPort);

    // Open up a task window so we can actually do the scheduling.
    final tasks = taskReceiver
        .takeWhile(
          (element) => element is Map<String, dynamic>,
        )
        .cast<Map<String, dynamic>>();

    // This is fine.
    await for (final task in tasks) {
      final computation = task["computation"];
      final dynamic Function(dynamic, StackTrace?) error = task["error"];
      final SendPort taskPort = task["sender"];
      final processor = task["processing"];
      final SendPort processed = task["processed"];

      //? This is fine.
      try {
        // This is fair enough.
        final result = await computation();

        // Next, if there is a post-processing function...
        if (processor != null) {
          // Obtain the post-processed result.
          final processedResult = await processor(result);

          // This is fine.
          processed.send(processedResult);
        }

        // NOW... you can send these results so that the completer can tell the
        // other guy that we are done. Since, we should have finished post-processing
        // in an edge-case scenario at this point.
        taskPort.send(result);
      } catch (e) {
        // This is fair enough.
        taskPort.send(
          error(
            e,
            e is Error ? e.stackTrace : null,
          ),
        );
      }
    }
  }

  /// This is a helper function that is used to execute a single task on the
  /// isolator that this task executor leaves running in the background.
  void execute<T>(Task task) async {
    // Send the task to the task to the
    try {
      // This is fair enough.
      communicatorSendPort.send(task._toSerializable());
    } catch (e) {
      // Complete with an error.
      task._resultPort.sendPort.send(
        task.onError(
          e,
          e is Error ? e.stackTrace : null,
        ),
      );
    }
  }

  /// A helper function used to pause the Isolate that the task executor is
  /// running on in order to ensure that we are not keeping an isolate running
  /// in the background at a time when we do not think it practical.
  void pause() {
    _capability = isolate.pause();
  }

  /// A helper function used to resume the execution of tasks in this task
  /// executor.
  void resume() {
    //? Only if there is something to do.
    if (_capability != null) {
      isolate.resume(_capability!);
      _capability = null; // Set this to null again.
    }
  }
}

/// The TaskScheduler class was created and it instantiates as many
/// TaskExecutor(s) as are available on the machine that is running our mobile
/// app.
///
/// Each task executor receives a Task which contains 3 callbacks:
///
/// 1. onComplete(result)
/// 2. onError(error, [stackTrace])
/// 3. computation()
///
/// The methods are self-explanatory therefore they would have no kind of
/// documentation here. The task scheduler uses the round-robin method to
/// schedule tasks until the there are no more tasks to schedule or consume. The
/// task scheduler can ONLY be created in an async context because we always want
/// to wait for the Isolates running these tasks to be created amongst other
/// things that need to happen asynchronously. The TaskScheduler bound to the
/// app is in-fact a property of the AppRegistry which is used internally to
/// schedule these tasks.
class TaskScheduler {
  /// The maximum number of isolates that can be run in parallel. This is the value
  /// determines how many tasks can be run in parallel inside any app that uses this
  /// library.
  static final int maxParallel = Platform.numberOfProcessors - 1;

  /// The list of all the isolates that were spawned in this application to
  /// assist with making the process of executing any given app using this core
  /// logic a lot smoother.
  final List<TaskExecutor> _isolates = [];

  /// The number that represents the index for the next isolate that should be
  /// round-robin scheduled to execute the next task.
  int _currentIsolate = 0;

  /// This is used to modify the value of current isolate appropriately to allow
  ///  scheduling feel more simple.
  TaskExecutor get _nextExecutor {
    // First, save the current isolate here.
    int old = _currentIsolate;

    // Now, increment this.
    _currentIsolate += 1;

    // If this is about where things stop...
    if (_currentIsolate >= _isolates.length) {
      _currentIsolate = 0; // Wrap around back to the beginning.
    }

    // Just return this value.
    return _isolates[old];
  }

  // Enclosed dummy constructor.
  TaskScheduler._();

  /// This creates a new scheduler that preserves the total number of processors
  /// on this machine as the current number of isolates that can be spawned and
  /// used to consume and execute computations in the background.
  static Future<TaskScheduler> init([int? maxParallel]) async {
    final scheduler = TaskScheduler._();
    final schedulerCount = maxParallel ?? TaskScheduler.maxParallel;

    //? Add a new task executor to the fold.
    int i = 0;
    do {
      scheduler._isolates.add(await TaskExecutor.init(i++, schedulerCount));
    } while (scheduler._isolates.length < schedulerCount);

    // Return the scheduler.
    return scheduler;
  }

  /// A helper function used to provision a function to run a new task on a dart
  /// isolate. It handles all the heavy logic associated with what to do when the
  /// number of tasks running are at the max possible value.
  Future<T> run<T>(Task<T> task) async {
    /// This should take the heavy lifting away from you kind of.
    final executor = _nextExecutor;
    final completer = Completer<T>();

    //? We can just listen to this asynchronously.
    task._resultPort.listen(
      (message) {
        task._resultPort.close();
        completer.complete(message as T);
      },
    );

    //? Now, we listen to the onProcess port.
    task._processPort.listen(
      (message) {
        task._processPort.close();

        // Call the onProcess callback with this result. Provided it exists.
        task._onProcess?.call(message);
      },
    );

    // Finally, we can just run the task.
    executor.execute<T>(task);

    // Fetch the result port of this thing.
    return completer.future;
  }
}
