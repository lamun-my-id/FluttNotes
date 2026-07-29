import 'package:datalocal/datalocal.dart';
import 'package:datalocal_sqlite/datalocal_sqlite.dart';
import 'package:flutter/foundation.dart';

DataLocalStorage createDefaultAppStorage({
  bool isWeb = kIsWeb,
  TargetPlatform? targetPlatform,
  DataLocalStorage Function()? sqliteFactory,
  DataLocalStorage Function()? sharedPreferencesFactory,
}) {
  final platform = targetPlatform ?? defaultTargetPlatform;
  final supportsSqlite =
      !isWeb &&
      (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS ||
          platform == TargetPlatform.macOS);
  return supportsSqlite
      ? (sqliteFactory ?? DataLocalSqliteStorage.new)()
      : (sharedPreferencesFactory ??
            DataLocalSharedPreferencesAsyncStorage.new)();
}

final class AppDatabase {
  AppDatabase._(this.database)
    : settings = database.mapCollection('settings'),
      notes = database.mapCollection('notes'),
      categories = database.mapCollection('categories'),
      reminders = database.mapCollection('reminders');

  final DataLocalDatabase database;
  final DataLocalCollection<Map<String, Object?>> settings;
  final DataLocalCollection<Map<String, Object?>> notes;
  final DataLocalCollection<Map<String, Object?>> categories;
  final DataLocalCollection<Map<String, Object?>> reminders;

  static Future<AppDatabase> open({
    DataLocalStorage? storage,
    DataLocalEncryptionProvider? encryption,
  }) async {
    const databaseName = 'fluttnotes-v2';
    final resolvedEncryption =
        encryption ??
        DataLocalAesGcmEncryptionProvider(
          keyProvider: DataLocalSecureStorageKeyProvider(
            databaseName: databaseName,
          ),
        );
    final database = await DataLocalDatabase.open(
      name: databaseName,
      storage: storage ?? createDefaultAppStorage(),
      encryption: resolvedEncryption,
    );
    return AppDatabase._(database);
  }

  Future<void> close() => database.close();
}
