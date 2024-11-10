import 'package:msbm_assessment_test/core/state/state.dart';

class FilesystemModel extends ObjectState {
  final String type;
  final DateTime lastModified;
  final DateTime lastAccessed;
  final String name;
  final String path;
  final List<FilesystemModel>? children;

  // Construct.
  FilesystemModel({
    required this.type,
    required this.lastModified,
    required this.lastAccessed,
    required this.name,
    required this.path,
    required this.children,
  });

  /// Utility used to create a filesystem model from a given feed of data.
  factory FilesystemModel.fromState(SavedStateData data) {
    return FilesystemModel(
      type: data["type"],
      lastModified: DateTime.parse(data["modified"]),
      lastAccessed: DateTime.parse(data["accessed"]),
      name: data["name"],
      path: data["path"],
      children: (data["children"] as List?)?.map((child) => FilesystemModel.fromState(child)).toList(),
    );
  }

  @override
  SavedStateData toSavedState() {
    return {
      "type": type,
      "modified": lastModified.toIso8601String(),
      "accessed": lastAccessed.toIso8601String(),
      "name": name,
      "path": path,

      //? If the children are not null...
      if (children != null) "children": children!.map((child) => child.toSavedState()).toList(),
    };
  }
}
