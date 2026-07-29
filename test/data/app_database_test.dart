import 'package:datalocal/datalocal.dart';
import 'package:datalocal_sqlite/datalocal_sqlite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttnotes/data/app_database.dart';

void main() {
  group('createDefaultAppStorage', () {
    test('uses SQLite on supported native platforms', () {
      expect(
        createDefaultAppStorage(targetPlatform: TargetPlatform.android),
        isA<DataLocalSqliteStorage>(),
      );
      expect(
        createDefaultAppStorage(targetPlatform: TargetPlatform.iOS),
        isA<DataLocalSqliteStorage>(),
      );
      expect(
        createDefaultAppStorage(targetPlatform: TargetPlatform.macOS),
        isA<DataLocalSqliteStorage>(),
      );
    });

    test('uses SharedPreferences on web and unsupported desktop platforms', () {
      final fallback = DataLocalMemoryStorage();
      DataLocalStorage createFallback() => fallback;

      expect(
        createDefaultAppStorage(
          isWeb: true,
          targetPlatform: TargetPlatform.android,
          sharedPreferencesFactory: createFallback,
        ),
        same(fallback),
      );
      expect(
        createDefaultAppStorage(
          targetPlatform: TargetPlatform.windows,
          sharedPreferencesFactory: createFallback,
        ),
        same(fallback),
      );
      expect(
        createDefaultAppStorage(
          targetPlatform: TargetPlatform.linux,
          sharedPreferencesFactory: createFallback,
        ),
        same(fallback),
      );
    });
  });
}
