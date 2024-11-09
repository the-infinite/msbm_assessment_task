import 'package:msbm_assessment_test/core/state/state.dart';
import 'package:msbm_assessment_test/models/filesystem.dart';
import 'package:msbm_assessment_test/repositories/filesystem.dart';

class FilesystemController extends StateController<FilesystemModel, FilesystemRepository> {
  FilesystemController({required super.repo}) {
    initialize(repository.cachedFilesystem);
  }
}
