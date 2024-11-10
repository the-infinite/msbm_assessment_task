import 'dart:io';

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
          "${path.absolute.path}${Platform.pathSeparator}MSBM${Platform.pathSeparator}TobiJohnson${Platform.pathSeparator}Drive${Platform.pathSeparator}";

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
    final unsorted = directory.listSync(recursive: true, followLinks: true);

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

  /// Controller function used to create the drive directory. This should only
  /// be used in situations where this doesn't exist.
  Future<void> createDriveDirectory() async {
    try {
      await (await driveDirectory).create(recursive: true);
      ModalHelper.showSnackBar("Drive directory has been created successfully", false);
      update();
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
}
