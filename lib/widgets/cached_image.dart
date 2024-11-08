import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:msbm_assessment_test/widgets/compose/placeholders.dart';

/// The list of entities that are currently being imported by this whatever.
final Map<String, Future<AppResponse>> _jobs = {};

/// This is how we either add this to the list of pending jobs, or retrieve it anyways.
Future<AppResponse> _getJob(String uri) {
  final found = _jobs[uri];

  //? Then return this.
  if (found != null) {
    return found;
  }

  // Else, start this and then add this to the list.
  final client = AppRegistry.find<AppClient>();
  final response = client.get(uri, useBase: false);

  // Then do it this way.
  _jobs[uri] = response;

  // Return this response.
  return response;
}

class CachedNetworkImage extends StatefulWidget {
  final String uri;
  final double? height;
  final double? width;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final double defaultHeight;
  final double defaultWidth;

  const CachedNetworkImage(
    this.uri, {
    super.key,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.medium,
    this.defaultHeight = 40,
    this.defaultWidth = 40,
    this.height,
    this.width,
  });

  @override
  State<CachedNetworkImage> createState() => _CachedNetworkImageState();
}

class _CachedNetworkImageState extends State<CachedNetworkImage> {
  // We do this here.
  File? _imageFile;
  bool _found = false;

  /// Utility method used to retrieve the name of the file to be uploaded as we
  /// would prefer to have it in our cache. This SHOULD include some information
  /// on topology inside the folder so that it is organized and guaranteed to be
  /// unique enough.
  String _getFilename() {
    final hashed = sha512.convert(utf8.encode(widget.uri)).toString();
    final segments = <String>[];
    String current = "";

    // Now, we fetch segments of a given length and then merge them into this as
    // needed.
    for (int i = 0; i < hashed.length; i++) {
      // Add this character...
      current += hashed[i];

      //? If this is up to our desired segment size.
      if (current.length == 32) {
        segments.add(current);
        current = "";
      }
    }

    //! If this still has content...
    if (current.isNotEmpty) {
      segments.add(current);
    }

    // Merge them and return them.
    return segments.join(Platform.pathSeparator);
  }

  /// Checks if this is the right image for this particular entity and only returns
  /// it if that is in fact the case.
  bool _isRightImage() {
    final index = (_imageFile?.path.indexOf("/image/") ?? -1) + 7;
    final found = _imageFile?.path.substring(index);
    final value = found == _getFilename();

    //? If this is not correct.
    if (!value) {
      AppRegistry.debugLog("Cache miss\nExpected name: ${_getFilename()}\nFound name: $found", "");
    }

    // This is fine.
    return value;
  }

  // The function we use as a utility internally to make sure we have got what
  // we are looking for.
  void _loadImage() async {
    // Then move forward.
    try {
      //? If this ends with null then it does not exist.
      if (widget.uri.endsWith("/null")) {
        if (mounted) {
          setState(() {
            _imageFile = null; // Show the placeholder image animation.
            _found = true;
          });
        }

        //! Stop so we do not waste compute time doing anything else.
        return;
      }

      //* First, prepare everything we need to do this.
      final source = (await getApplicationCacheDirectory()).absolute.path;
      final filename = _getFilename();
      final path = "$source/image/$filename";
      File found = File(path);

      //? If this file exists in our cache of images....
      if (await found.exists() && found.lengthSync() != 0) {
        if (mounted) {
          setState(() {
            _imageFile = found;
            _found = true;
          });
        }

        // Do this one.
        return;
      }

      //? Since this does not exist, we download and build it.
      final result = await _getJob(widget.uri);

      //! If this was not successful, show the placeholder image animation and
      //! then break.
      if (!result.isOk) {
        if (mounted) {
          setState(() {
            _found = true;
            _imageFile = null; // Show the placeholder image animation.
          });
        }
        AppRegistry.debugLog("Unable to download image resource", "Widgets.CachedImage");
        return;
      }

      // Since this was fine, update this value.
      found = await found.create(recursive: true);
      found = await found.writeAsBytes(result.bytes, flush: true);

      // Then just do this.
      if (mounted) {
        // If this is fine.
        setState(() {
          _imageFile = found;
          _found = true;
        });
      }
    } catch (e) {
      AppRegistry.debugLog(e, "Widgets.CachedImage");
    }
  }

  // Build the widget.
  @override
  Widget build(BuildContext context) {
    //? If there is no image file bound to this yet, attach an image right
    //? away.
    if (!_found) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _loadImage();
        },
      );
    }

    // If this is not ready yet
    if (_imageFile == null || !_isRightImage()) {
      //? Break this away.
      _found = false;

      // This is fair enough.
      return PlaceholderImage(
        width: widget.width ?? widget.defaultWidth,
        height: widget.height ?? widget.defaultHeight,
      );
    }

    // Since it is now ready...
    return Image.file(
      _imageFile!,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      filterQuality: widget.filterQuality,
      errorBuilder: (context, error, stackTrace) {
        // Log any issues that might arise.
        AppRegistry.debugLog(error, "Widgets.CachedImage");

        try {
          setState(() {
            _imageFile = null;
          });
        } catch (e) {
          AppRegistry.debugLog(e, "Widgets.CachedImage");
        }

        // Send this image forth.
        return PlaceholderImage(
          width: widget.width ?? widget.defaultWidth,
          height: widget.height ?? widget.defaultHeight,
        );
      },
    );
  }
}
