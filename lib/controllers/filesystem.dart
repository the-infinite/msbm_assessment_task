import 'dart:io';

import 'package:msbm_assessment_test/controllers/app.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/helper/modals.dart';
import 'package:msbm_assessment_test/models/filesystem.dart';
import 'package:msbm_assessment_test/repositories/filesystem.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watcher/watcher.dart';

class FilesystemController extends StateController<FilesystemModel, FilesystemRepository> {
  String _drivePath = "";
  String _currentPath = "";
  Stream<WatchEvent>? _filesystemWatcher;

  /// A controller property used to retrieve the path that is currently in focus.
  /// It is how we know what directory is currently in view in the file browser.
  String get currentPath => _currentPath;

  /// A controller property used to retrieve the path that is currently in use
  /// for the drive directory.
  String get drivePath => _drivePath;

  /// A controller utility used to obtain the directory that is mounted to this
  /// drive to make life a lot easier.
  Future<Directory> get driveDirectory async {
    //? Only do this when the drive path is empty.
    if (_drivePath.isEmpty) {
      final path = await getApplicationSupportDirectory();

      // Update the drive path.
      _drivePath =
          "${path.absolute.path}${Platform.pathSeparator}MSBM${Platform.pathSeparator}TobiJohnson${Platform.pathSeparator}Drive";

      //? This is fine.
      _currentPath = _drivePath;
    }

    //? This is where we do it.
    return Directory(_drivePath);
  }

  /// Controller utility used to check whether or not the drive directory exists.
  /// Used to understand the state of the drive menu to show when the app is
  /// started.
  Future<bool> get doesDriveDirectoryExist async {
    return (await driveDirectory).exists();
  }

  /// Controller function used to watch the contents of the drive directory. This
  /// intentionally returns a stream.
  Stream<WatchEvent> get filesystemWatcher async* {
    //? If this is not yet defined.
    if (_filesystemWatcher == null) {
      final drive = await driveDirectory;
      final watcher = DirectoryWatcher(drive.path);

      //? Now, listen and then update the saved file structure every time it
      //? changes
      watcher.events.listen(
        (event) {
          silentSyncChanges();
        },
      );

      //? This is fine.
      _filesystemWatcher = watcher.events;
    }

    //? This is fine.
    yield WatchEvent(ChangeType.ADD, _drivePath);

    //? Then return this one.
    yield* _filesystemWatcher!;
  }

  /// Controller function used to get the contents of the drive that is currently
  /// in focus.
  List<FileSystemEntity> get workingDirectoryView {
    //? First, get these ones.
    final directory = Directory(_currentPath);
    final unsorted = directory.listSync(recursive: false, followLinks: true);

    //? Remove the entities we might not otherwise need.
    unsorted.removeWhere((entry) {
      final filename = getFilename(entry.path);
      return filename == "." || filename == "..";
    });

    //? Then we split it into the directories and the files.
    final directories = unsorted.where((entry) => entry.statSync().type == FileSystemEntityType.directory).toList();
    final files = unsorted.where((entry) => entry.statSync().type != FileSystemEntityType.directory).toList();

    //? Sort the directories and the files.
    directories.sort(
      (first, second) {
        final firstFile = getFilename(first.path);
        final nextFile = getFilename(second.path);
        return firstFile.compareTo(nextFile);
      },
    );

    //? Sort the directories and the files.
    files.sort(
      (first, second) {
        final firstFile = getFilename(first.path);
        final nextFile = getFilename(second.path);
        return firstFile.compareTo(nextFile);
      },
    );

    //? Then return the merged list with the directories before the files.
    return [
      ...directories,
      ...files,
    ];
  }

  // Construct.
  FilesystemController({required super.repo}) {
    initialize(repository.cachedFilesystem);
  }

  /// This is used to update the controller with the most recently cached version
  /// on disk.
  @override
  Future<void> restoreState([FilesystemModel? state]) async {
    invalidate(state ?? repository.cachedFilesystem);
  }

  /// Controller function used to create the drive directory. This should only
  /// be used in situations where this doesn't exist.
  Future<void> createDriveDirectory() async {
    try {
      await (await driveDirectory).create(recursive: true);
      ModalHelper.showSnackBar("Drive directory has been created successfully", false);
    } catch (e) {
      ModalHelper.showSnackBar(
        "Unable to create drive directory because ${e.toString().toLowerCase()}",
      );
    }
  }

  /// Controller utility function that can be used to create a new folder in a
  /// given directory.
  Future<bool> createFolder(String path) async {
    //? After creating this directory...
    final directory = await Directory(path).create(recursive: true);

    //? Update this one.
    update();

    //? Return whether or not this directory now exists.
    return directory.exists();
  }

  /// Controller utility function that can be used to create a new file in a
  /// given directory.
  Future<bool> createFile(String path) async {
    //? After creating this directory...
    final directory = await File(path).create(recursive: true);

    //? Return whether or not this directory now exists.
    return directory.exists();
  }

  /// Controller utility used to get the name of a file. Useful when we are
  /// trying to show what name of a file can be displayed in this part.
  String getFilename(String path) {
    final parts = path.split(Platform.pathSeparator);

    //? Return the name of this file.
    return parts.last.isEmpty ? parts[parts.length - 2] : parts.last;
  }

  /// Controller utility used to synchronize the local state of the filesystem
  /// and then use it to angle over to the remote side of things.
  Future<void> syncChanges() async {
    final app = AppRegistry.find<AppController>();

    //? Now, do the needful.
    app.setSyncingState();
    final result = await repository.cacheFilesystem(_drivePath);

    //? This is fine.
    if (result) {
      ModalHelper.showSnackBar("Drive folder synced successfully", false);
      await restoreState();
    }

    //? Since it failed
    else {
      ModalHelper.showSnackBar("Failed to synchronize drive folder");
    }

    //? Then we do the needful here.
    app.setSyncingFinishedState();

    //? Then after a 2 seconds long delay...
    await Future.delayed(const Duration(seconds: 2));

    //? Set the default app icon.
    app.setSyncingNoneState();
  }

  /// Controller utility used to synchronize the local state of the filesystem
  /// and then use it to angle over to the remote side of things.
  Future<void> silentSyncChanges() async {
    final app = AppRegistry.find<AppController>();

    // Obtain the result first.
    app.setSyncingState();
    final result = await repository.cacheFilesystem(_drivePath);

    //? This is fine.
    if (result) {
      app.sendNotification("Drive synchronized successfully");
      await restoreState();
    }

    //? Since it failed
    else {
      app.sendNotification("Failed to synchronize drive folder");
    }

    //? Then we do the needful here.
    app.setSyncingFinishedState();

    //? Then after a 2 seconds long delay...
    await Future.delayed(const Duration(seconds: 2));

    //? Set the default app icon.
    app.setSyncingNoneState();
  }

  /// Controller utility used to check whether or not a file has been synced.
  bool isSynced(FileSystemEntity file) {
    //? First, get the cached filesystem.
    final cached = currentState;

    //! If there is no cached filesystem yet...
    if (cached == null) return false;

    //? Since there is a cached filesystem
    final data = file.statSync();
    final found = _lookupFile(cached, file);

    //? If this has been deleted but that deletion has not been synced...
    if (found == null) return false;

    //? Let's check the modification time.
    return found.lastModified.isAtSameMomentAs(data.modified);
  }

  /// Controller utility used to update the current path we are looking into.
  void setPath(String path) {
    _currentPath = path;

    update();
  }

  /// Controller utility used to look for a given file/folder in the entire file
  /// tree that is cached. Using the JSON key to look for it.
  FilesystemModel? _lookupFile(FilesystemModel root, FileSystemEntity file) {
    //? If this is the location we are looking into.
    if ("${root.path}${Platform.pathSeparator}${root.name}" == file.path) return root;

    //? Since this is a folder...
    for (final child in root.children ?? []) {
      final result = _lookupFile(child, file);

      //? This is fine.
      if (result != null) return result;
    }

    //? This is fine.
    return null;
  }
}
