import 'package:flutter/material.dart';
import 'package:datalocal/datalocal.dart';

class NotesProvider with ChangeNotifier {
  late DataLocal data;
  bool isLoading = false;
  List<DataItem> notes = [];

  NotesProvider() {
    isLoading = true;
    refresh();
    initialize();
  }

  initialize() async {
    // print("object");
    data = await DataLocal.create(
      "notes2",
      onRefresh: () => refresh(),
      // debugMode: true,
    );
    data.onRefresh = () async {
      notes = await data.find(
        sorts: [
          DataSort(key: DataKey("createdAt"), desc: true),
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
        });
      }
    }
  }

  onUpdate(String id, {required String title, required String content}) async {
    data.updateOne(id, value: {
      "title": title,
      "content": content,
      "updatedAt": DateTime.now(),
    });
  }

  onDeleted(String id) async {
    data.deleteOne(id);
  }
}
