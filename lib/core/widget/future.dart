import 'package:flutter/material.dart';

/// A utility widget that is used to subscribe to a Future in order to create a
/// visual representation on screen based on whatever state the widget is
/// currently in. This has three kinds of builders which correspond to different
/// states of the future.
///
/// The first builder is the [suspenseBuilder] which returns
/// the view to show when this Future is not yet completed.
///
/// The second is the [errorBuilder] which returns the view to show when this
/// Future completed with an errors.
///
/// The third is the [builder] which returns the view to show when this completed
/// successfully.
class FutureSubscriber<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T? result) builder;
  final Widget Function(BuildContext context) suspenseBuilder;
  final Widget Function(BuildContext context, dynamic error, StackTrace? stackTrace) errorBuilder;

  const FutureSubscriber({
    super.key,
    required this.future,
    required this.suspenseBuilder,
    required this.errorBuilder,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        //? If this is pending...
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
          return suspenseBuilder(context);
        }

        //? If this is completed with errors...
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasError) {
          return errorBuilder(context, snapshot.error, snapshot.stackTrace);
        }

        //? Else, just return this thing and its result.
        return builder(context, snapshot.data);
      },
    );
  }
}
