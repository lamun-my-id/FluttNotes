import 'package:datalocal/datalocal.dart';
import 'package:datalocal/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/reminders_provider.dart';
import 'package:fluttnotes/screens/reminders/reminders_form_screen.dart';
import 'package:provider/provider.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    RemindersProvider r = Provider.of<RemindersProvider>(context);
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(),
            Expanded(
              child: SizedBox(
                child: Builder(builder: (context) {
                  if (r.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (r.data.data.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.checklist_outlined,
                          size: 32,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "No task here yet",
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
                      // vertical: 16,
                    ),
                    itemCount: r.data.count,
                    itemBuilder: (_, index) {
                      DataItem d = r.data.data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RemindersFormScreen(
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
                            // height: 100,
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
                                Column(
                                  children: List.generate(
                                      (d.get("content") ?? []).length,
                                      (index2) {
                                    Map<String, dynamic> task =
                                        (d.get("content") ?? [])[index2];
                                    return SizedBox(
                                      width: width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Checkbox(
                                              value: task['checklist'] ?? false,
                                              onChanged: (_) {
                                                task['checklist'] = _;
                                                setState(() {});
                                                r.onSave(
                                                  id: d.id,
                                                  title: d.get('title'),
                                                  date: d.get("date"),
                                                  content: List<
                                                          Map<String,
                                                              dynamic>>.from(
                                                      (d.get("content") ?? [])),
                                                );
                                                // print("saved");
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: width,
                                              constraints: const BoxConstraints(
                                                minHeight: 50,
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                task['controller'],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RemindersFormScreen(),
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
