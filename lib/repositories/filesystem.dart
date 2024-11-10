import 'dart:convert';
import 'dart:io';

import 'package:msbm_assessment_test/core/data/repo.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/models/filesystem.dart';

class FilesystemRepository extends DataRepository {
  /// Repository utility used to get the cached instance of the filesystem from
  /// the local storage.
  FilesystemModel? get cachedFilesystem {
    final saved = localStorage.getString(AppConstants.filesystem);

    //? If this is undefined, return this as is.
    if (saved == null) return null;

    //? Since we found something...
    return FilesystemModel.fromState(jsonDecode(saved));
  }

  /// Controller utility used to get the name of a file. Useful when we are
  /// trying to show what name of a file can be displayed in this part.
  String _getFilename(String path) {
    final parts = path.split(Platform.pathSeparator);

    //? Return the name of this file.
    return parts.last.isEmpty ? parts[parts.length - 2] : parts.last;
  }

  /// A repository utility used to calculate the children of a given folder.
  List<FilesystemModel> _calculateChildren(String path) {
    final result = <FilesystemModel>[];
    final directory = Directory(path);

    //? Enumerate the entities...
    final childs = directory.listSync();

    //* For each child inside this directory...
    for (final child in childs) {
      final data = child.statSync();
      final isDirectory = data.type == FileSystemEntityType.directory;

      //?
      result.add(
        FilesystemModel(
          type: isDirectory ? "folder" : "file",
          lastModified: data.modified,
          lastAccessed: data.accessed,
          name: _getFilename(child.path),
          path: child.parent.path,
          children: isDirectory ? _calculateChildren(child.path) : null,
        ),
      );
    }

    //? Return
    return result;
  }

  /// A repository utility function used to cache the entire filesystem so that
  /// it becomes a lot easier and more passable for this to work correctly.
  Future<bool> cacheFilesystem(String path) async {
    final directory = Directory(path);
    final data = directory.statSync();

    //? This is the cached representation of this filesystem.
    final cached = FilesystemModel(
      type: "folder",
      lastModified: data.modified,
      lastAccessed: data.accessed,
      name: _getFilename(path),
      path: directory.parent.path,
      children: _calculateChildren(path),
    );

    // Then wait for this to end.
    await Future.delayed(const Duration(seconds: 2));

    //? Now, we need to do the needful.
    return localStorage.setString(AppConstants.filesystem, jsonEncode(cached.toSavedState()));
  }
}
