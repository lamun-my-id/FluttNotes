import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttnotes/data/app_database.dart';
import 'package:fluttnotes/main.dart';

void main() {
  testWidgets('starts without provider initialization errors', (tester) async {
    final database = await AppDatabase.open(
      storage: DataLocalMemoryStorage(),
      encryption: const DataLocalNoEncryptionProvider(),
    );

    try {
      await tester.pumpWidget(MyApp(database: database));
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
      expect(find.byType(Tab), findsNWidgets(2));
      expect(find.byIcon(Icons.edit_note_rounded), findsWidgets);
      expect(find.byIcon(Icons.checklist_outlined), findsWidgets);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await database.close();
    }
  });
}
