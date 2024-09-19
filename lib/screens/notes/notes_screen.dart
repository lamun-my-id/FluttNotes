import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/categories_provider.dart';
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
    CategoriesProvider c = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              width: width,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        n.changeCategory(null);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: n.category == null
                              ? const Color(0xFFFCFCFD)
                              : Colors.grey[200]!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("All"),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        n.changeCategory({"id": null});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: n.category != null && n.category!['id'] == null
                              ? const Color(0xFFFCFCFD)
                              : Colors.grey[200]!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Uncategorized"),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    FutureBuilder<DataQuery>(
                      future: c.data.find(
                        sorts: [
                          DataSort(
                            key: DataKey(c.sort['value'],
                                onKeyCatch: "createdAt"),
                            desc: c.sort['desc'] ?? true,
                          ),
                        ],
                      ),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }
                        DataQuery query = snapshot.data!;
                        List<DataItem> datas = query.data;
                        return Row(
                          children: List.generate(datas.length, (_) {
                            DataItem d = datas[_];
                            return Row(
                              children: [
                                if (_ > 0)
                                  const SizedBox(
                                    width: 8,
                                  ),
                                InkWell(
                                  onTap: () {
                                    n.changeCategory({
                                      "id": d.id,
                                      "name": d.get(DataKey("name")),
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: n.category != null &&
                                              n.category!['id'] == d.id
                                          ? const Color(0xFFFCFCFD)
                                          : Colors.grey[200]!,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(d.get(DataKey("name")) ?? ""),
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (n.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return FutureBuilder<DataQuery>(
                    future: n.data.find(
                      sorts: [
                        DataSort(
                          key:
                              DataKey(n.sort['value'], onKeyCatch: "createdAt"),
                          desc: n.sort['desc'] ?? true,
                        ),
                      ],
                      filters: n.category == null
                          ? null
                          : n.category!['id'] == null
                              ? [
                                  DataFilter(
                                      key: DataKey("category"), value: null)
                                ]
                              : [
                                  DataFilter(
                                      key: DataKey("category.id"),
                                      value: n.category!['id'])
                                ],
                    ),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        if (n.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                      DataQuery query = snapshot.data!;
                      List<DataItem> datas = query.data;

                      if (datas.isEmpty) {
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
                        itemCount: datas.length,
                        itemBuilder: (_, index) {
                          DataItem d = datas[index];
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
                                  border: Border.all(
                                      color: const Color(0xFFE4E7EC)),
                                ),
                                child: Column(
                                  children: [
                                    // SizedBox(
                                    //   width: width,
                                    //   child: Text(
                                    //     d.get(DataKey("category")) ?? "",
                                    //     maxLines: 1,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: const TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 16,
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: width,
                                      child: Text(
                                        d.get(DataKey("title")) ?? "",
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
                                        d.get(DataKey("content")) ?? "",
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
                                                  d.get(DataKey("createdAt")) ??
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
