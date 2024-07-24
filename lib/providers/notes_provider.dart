import 'package:flutter/material.dart';
import 'package:datalocal/datalocal.dart';

class NotesProvider with ChangeNotifier {
  late DataLocal data;
  bool isLoading = false;
  List<DataItem> notes = [];
  Map<String, dynamic> sort = {"value": "updatedAt"};
  Map<String, dynamic>? category;

  NotesProvider() {
    isLoading = true;
    refresh();
    initialize();
  }

  initialize() async {
    // print("object");
    data = await DataLocal.create(
      "notes",
      onRefresh: () => refresh(),
      // debugMode: true,
    );
    data.onRefresh = () async {
      notes = await data.find(
        sorts: [
          DataSort(
            key: DataKey(sort['value'], onKeyCatch: "createdAt"),
            desc: sort['desc'] ?? true,
          ),
        ],
        filters: category == null
            ? null
            : category!['id'] == null
                ? [DataFilter(key: DataKey("category"), value: null)]
                : [
                    DataFilter(
                        key: DataKey("category.id"), value: category!['id'])
                  ],
      );
      refresh();
    };
    data.refresh();
    isLoading = false;
    refresh();
  }

  void refresh() {
    notifyListeners();
  }

  void changeSort(Map<String, dynamic> value) {
    sort = value;
    refresh();
    data.refresh();
  }

  void changeCategory(Map<String, dynamic>? value) {
    category = value;
    refresh();
    data.refresh();
  }

  Future<DataItem?> save(
      {String? id, required String title, required String content}) async {
    if (id != null) {
      if (title.isNotEmpty || content.isNotEmpty) {
        return await onUpdate(id, title: title, content: content);
      }
    } else {
      if (title.isNotEmpty || content.isNotEmpty) {
        return await data.insertOne({
          "title": title,
          "content": content,
          "updatedAt": DateTime.now(),
          "category": category,
        });
      }
    }
    return null;
  }

  onSave({String? id, required String title, required String content}) async {
    if (id != null) {
      if (title.isNotEmpty || content.isNotEmpty) {
        onUpdate(id, title: title, content: content);
      } else {
        onDeleted(id);
      }
    } else {
      if (title.isNotEmpty || content.isNotEmpty) {
        data.insertOne({
          "title": title,
          "content": content,
          "updatedAt": DateTime.now(),
          "category": category,
        });
      }
    }
  }

  onUpdate(String id, {required String title, required String content}) async {
    data.updateOne(id, value: {
      "title": title,
      "content": content,
      "updatedAt": DateTime.now(),
      "category": category,
    });
  }

  onDeleted(String id) async {
    data.deleteOne(id);
  }
}
