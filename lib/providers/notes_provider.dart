import 'package:flutter/material.dart';
import 'package:datalocal/datalocal.dart';

class NotesProvider with ChangeNotifier {
  late DataLocal data;
  bool isLoading = false;

  NotesProvider() {
    isLoading = true;
    refresh();
    initialize();
  }

  initialize() async {
    // print("object");
    data = await DataLocal.create("notes2",
        onRefresh: () => refresh(), debugMode: true);
    data.onRefresh = () {
      refresh();
    };
    data.refresh();
    isLoading = false;
    refresh();
  }

  void refresh() {
    notifyListeners();
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
