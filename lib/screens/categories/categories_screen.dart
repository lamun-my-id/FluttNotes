import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/categories_provider.dart';
import 'package:fluttnotes/providers/notes_provider.dart';
import 'package:fluttnotes/screens/categories/categories_form_screen.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    CategoriesProvider c = Provider.of<CategoriesProvider>(context);
    NotesProvider n = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Builder(
          builder: (_) {
            if (c.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (c.categories.isEmpty) {
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
                    "No categories here yet",
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
              itemCount: c.categories.length,
              itemBuilder: (_, index) {
                DataItem d = c.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoriesFormScreen(
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
                      height: 60,
                      width: width,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCFCFD),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE4E7EC)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width,
                            child: Text(
                              d.get(DataKey("name")) ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoriesFormScreen(),
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
