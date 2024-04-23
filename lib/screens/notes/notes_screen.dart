import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/notes_provider.dart';
import 'package:fluttnotes/screens/notes/notes_form_screen.dart';
import 'package:fluttnotes/utils/date_time_util.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    NotesProvider n = Provider.of<NotesProvider>(context);
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Column(
          children: [
            Container(),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (n.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (n.notes.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit_note_rounded,
                          size: 32,
                          color: Color(0xFF1F325D),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "No notes here yet",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400]!,
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 86,
                      // vertical: 16,
                    ),
                    itemCount: n.notes.length,
                    itemBuilder: (_, index) {
                      DataItem d = n.notes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotesFormScreen(
                                  value: d,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            height: 100,
                            width: width,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCFCFD),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE4E7EC)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: width,
                                  child: Text(
                                    d.get("title") ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width,
                                  child: Text(
                                    d.get("content") ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                SizedBox(
                                  width: width,
                                  child: Text(
                                    DateTimeUtils.dateFormat(
                                          d.createdAt ??
                                              d.get("createdAt") ??
                                              "",
                                          format: "MMMM dd",
                                          locale: "en",
                                        ) ??
                                        "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NotesFormScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1F325D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
