import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/notes_provider.dart';
import 'package:fluttnotes/providers/reminders_provider.dart';
import 'package:fluttnotes/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => NotesProvider(),
        ),
        ChangeNotifierProvider<RemindersProvider>(
          create: (_) => RemindersProvider(),
        ),
      ],
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FluttNotes',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF1F325D)),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(textTheme),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
