import 'package:datalocal/datalocal.dart';

typedef MapDocument = DataLocalDocument<Map<String, Object?>>;
typedef DataItem = MapDocument;
typedef DataQuery = DataLocalQuerySnapshot<Map<String, Object?>>;

final class DataKey {
  const DataKey(this.path, {this.onKeyCatch});

  final String path;
  final String? onKeyCatch;
}

extension MapDocumentFields on MapDocument {
  dynamic get(DataKey key) => field(key.path) ?? field(key.onKeyCatch ?? '');

  dynamic field(String path) {
    Object? current = data;
    for (final segment in path.split('.')) {
      if (current is! Map<String, Object?> || !current.containsKey(segment)) {
        return switch (path) {
          'createdAt' => createdAt,
          'updatedAt' => updatedAt,
          'revision' => revision,
          'id' => id,
          _ => null,
        };
      }
      current = current[segment];
    }
    return current;
  }
}

extension MapQuerySnapshotDocuments on DataQuery {
  List<MapDocument> get data => documents;
}
