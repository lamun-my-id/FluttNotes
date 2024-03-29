import 'package:flutter/material.dart';
import 'package:fluttnotes/screens/notes/notes_screen.dart';
import 'package:fluttnotes/screens/reminders/reminders_screen.dart';
import 'package:fluttnotes/screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                SizedBox(
                  height: height,
                  width: width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: width,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SizedBox()),
                            SizedBox(
                              width: 120,
                              height: 60,
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                indicatorColor: Colors.transparent,
                                tabs: [
                                  Tab(
                                    icon: Icon(Icons.edit_note_rounded),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.checklist_outlined),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            NotesScreen(),
                            RemindersScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.settings_outlined,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}