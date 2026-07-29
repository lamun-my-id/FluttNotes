import 'package:flutter/material.dart';
import 'package:fluttnotes/data/app_database.dart';
import 'package:fluttnotes/providers/app_provider.dart';
import 'package:fluttnotes/providers/categories_provider.dart';
import 'package:fluttnotes/providers/notes_provider.dart';
import 'package:fluttnotes/providers/reminders_provider.dart';
import 'package:fluttnotes/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final database = await AppDatabase.open();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (_) => AppProvider(database.settings),
        ),
        ChangeNotifierProvider<CategoriesProvider>(
          create: (_) => CategoriesProvider(database.categories),
        ),
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => NotesProvider(database.notes),
        ),
        ChangeNotifierProvider<RemindersProvider>(
          create: (_) => RemindersProvider(database.reminders),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FluttNotes',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1F325D),
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(textTheme),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
