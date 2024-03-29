import 'package:datalocal/datalocal.dart';
import 'package:datalocal/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/notes_provider.dart';
import 'package:fluttnotes/screens/notes/notes_form_screen.dart';
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
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(),
            Expanded(
              child: Builder(builder: (context) {
                if (n.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (n.data.data.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_note_rounded,
                        size: 32,
                        color: Colors.deepPurple,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: n.data.count,
                  itemBuilder: (_, index) {
                    DataItem d = n.data.data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(),
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
                                          format: "MMMM dd") ??
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
              }),
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
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
