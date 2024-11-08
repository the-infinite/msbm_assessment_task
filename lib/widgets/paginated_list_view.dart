import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/widget/boundary.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/widgets/dynamic_height_gridview.dart';

/// A utility widget that helps to create a paginated list using a dependency
/// called [DynamicHeightGridView]  The logic that is meant to manage most
/// of its behavior can be somewhat inferred upon looking at its properties and their
/// names. You could also read through the code to get a deeper understanding
/// of how it works.
class PaginatedListView extends StatelessWidget {
  /// The layout of this paginated list view. Is it vertical, or horizontal?
  final Axis direction;

  /// The first page that `this` [PaginatedListView] must work from as the first
  /// page. If you (for some reason), want to put this in a stateful parent, you
  /// must set this value appropriately or you would get undefined behavior.
  final int initialPage;

  /// The physics you are using for this scroll controller.
  final ScrollPhysics physics;

  /// The [ScrollController] to use. This can be null and does in fact default
  /// to null. If this is actually null, `this` [PaginatedListView] would create
  /// and use its own [ScrollController] to listen for the scroll offset.
  final ScrollController? scrollController;

  /// The widget to leave in the screen when there is no content to show on the
  /// screen. This would only get called whenever the [PaginatedListView.loadMore]
  /// function returns `0`.
  final Widget child;

  /// How many items are currently in this paginated list view.
  final int itemCount;

  /// A builder function that is used to create the view for each child of the
  /// [PaginatedListView] that contains data.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// A builder function that is used to create the view for each child of the
  /// [PaginatedListView] that contains no data. These ones are placeholders
  /// that exist there until you get to the end of the line.
  final Widget Function(BuildContext context, int index) placeholderBuilder;

  /// A [Future] that is used to retrieve the next entries to use to populate
  /// the list. This callback takes the page to show next as an argument and
  /// MUST return the current size of the [List], [Set], or whatever kind of data
  /// structure you are using to compile the data.
  final Future<int> Function(int page) loadMore;

  /// A callback made to check whether there is no longer a need to fetch more
  /// data when the user scrolls to the end.
  final bool Function() isAtEnd;

  /// The number of items in the cross axis.
  final int crossAxisCount;

  /// The amount of spacing to keep between elements in the cross axis.
  final double crossAxisSpacing;

  /// The amount of spacing to keep between elements in the main axis.
  final double mainAxisSpacing;

  /// The ratio to cross axis extent and main axis extent of each child.
  final double childAspectRatio;

  /// The maximum height this paginated list view can stretch. This is only a
  /// valid entry when this is horizontally laid out.
  final double constraintHeight;

  /// Should this scroll to the bottom automatically after every load?
  final bool scrollToEnd;

  /// The loading controller for this paginated list view.
  final ValueNotifier<bool> loadingController;

  /// Construct.
  const PaginatedListView({
    super.key,
    required this.initialPage,
    required this.itemCount,
    required this.child,
    required this.itemBuilder,
    required this.placeholderBuilder,
    required this.loadMore,
    required this.isAtEnd,
    required this.loadingController,
    this.scrollToEnd = false,
    this.constraintHeight = double.infinity,
    this.crossAxisCount = 1,
    this.crossAxisSpacing = Dimensions.paddingSizeDefault,
    this.mainAxisSpacing = Dimensions.paddingSizeLarge,
    this.childAspectRatio = 1,
    this.physics = const BouncingScrollPhysics(),
    this.direction = Axis.vertical,
    this.scrollController,
  });

  /// Used to fetch more data to render in the paginated list view when there is
  /// nothing to show.
  @override
  Widget build(BuildContext context) {
    final controller = scrollController ?? ScrollController();

    // Helper function used to fetch more data to load here.
    Future<bool> fetchMore() async {
      // This is fine.
      if (isAtEnd() || loadingController.value) {
        return false;
      }

      // Then this is fair.
      try {
        loadingController.value = true;

        // Log this here.
        AppRegistry.debugLog("Triggering loading page $initialPage of data.", "PaginatedListView.$hashCode");

        // Now, do this.
        await loadMore(initialPage);

        // Update the state of these things.
        loadingController.value = false;

        //? If this is fine.
        if (scrollToEnd) {
          controller.jumpTo(controller.position.maxScrollExtent);
        }

        // Return the value.
        return true;
      } catch (e) {
        AppRegistry.debugLog(e, "Widgets.Paginator");
        loadingController.value = false;

        // Return false.
        return false;
      }
    }

    // First add this one.
    void getMore() {
      //? If this is still loading, fail.
      if (loadingController.value) {
        AppRegistry.debugLog("Skipping load request because this paginator is already loading.", "Widgets.Paginator");
        AppRegistry.debugLog("Current Offset: ${controller.offset}", "Widgets.Paginator");
        AppRegistry.debugLog("Max Scrollable: ${controller.position.maxScrollExtent}", "Widgets.Paginator");
        return;
      }

      // Don't wait until you get to the end. Start fetching when you are 85% there.
      if (controller.offset > controller.position.maxScrollExtent * 0.85) {
        fetchMore();
      }
    }

    // Now, load the first page of content when this is over.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchMore();
    });

    // Our content loader logic.
    controller.addListener(getMore);

    // If this is definitely empty and we can stop looking....
    if (itemCount == 0 && isAtEnd()) {
      return child;
    }

    // Return this.
    return InterceptorBoundary(
      onPopInvoked: () {
        try {
          // Try to remove this if it is still there.
          controller.removeListener(getMore);

          // If this did created its own scroll controller...
          if (scrollController == null) {
            controller.dispose(); // Dispose of it.
          }
        } catch (_) {}

        // Always allow this to leave.
        return true;
      },
      child: ValueListenableBuilder(
        valueListenable: loadingController,
        builder: (context, isLoading, _) {
          // Since this is fine.
          int length = itemCount;

          //? If this is not at the end.
          if (isLoading) {
            length += 15; // Add the loading placeholders.
          }

          //? When we get to the end, remove the listener.
          if (isAtEnd()) {
            controller.removeListener(getMore);
          }

          // Now, build and return this widget.
          return DynamicHeightGridView(
            controller: scrollController == null ? controller : null,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisCount: crossAxisCount,
            physics: physics,
            itemCount: length,
            direction: direction,
            height: constraintHeight,
            shrinkWrap: true,
            builder: (context, index) {
              // If this is the first thing...
              if (index < itemCount) {
                return itemBuilder(context, index);
              }

              // If this is at the end of its rope, return nothing. The code would
              // never get here but we account for such a situation anyways.
              else if (isAtEnd()) {
                return const SizedBox();
              }

              // Since this is the end of the line, we do more work.
              else {
                return placeholderBuilder(context, index);
              }
            },
          );
        },
      ),
    );
  }
}
