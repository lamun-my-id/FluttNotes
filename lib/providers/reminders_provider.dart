import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';

class RemindersProvider with ChangeNotifier {
  late DataLocal data;
  bool isLoading = false;
  List<DataItem> reminders = [];

  RemindersProvider() {
    isLoading = true;
    refresh();
    initialize();
  }

  initialize() async {
    data = await DataLocal.create(
      "reminder",
      onRefresh: () => refresh(),
      // debugMode: true,
    );
    data.onRefresh = () async {
      reminders = await data.find(
        sorts: [
          DataSort(
            key: DataKey("createdAt"),
            desc: true,
          ),
        ],
      );
      refresh();
    };
    data.refresh();
    isLoading = false;
    refresh();
  }

  Future<DataItem?> save({
    String? id,
    required String title,
    required DateTime? date,
    required List<Map<String, dynamic>> content,
  }) async {
    if (id != null) {
      if (title.isNotEmpty ||
          content.length >= 2 ||
          content.first['controller'].toString().isNotEmpty) {
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

  onSave({
    String? id,
    required String title,
    required DateTime? date,
    required List<Map<String, dynamic>> content,
  }) async {
    if (id != null) {
      if (title.isNotEmpty ||
          content.length >= 2 ||
          content.first['controller'].toString().isNotEmpty) {
        onUpdate(id, title: title, content: content);
      } else {
        onDeleted(id);
      }
    } else {
      if (title.isNotEmpty ||
          content.first['controller'].toString().isNotEmpty) {
        data.insertOne({
          "title": title,
          "content": content,
          "updatedAt": DateTime.now(),
        });
      }
    }
  }

  onUpdate(String id,
      {required String title,
      required List<Map<String, dynamic>> content}) async {
    return await data.updateOne(id, value: {
      "title": title,
      "content": content,
      "updatedAt": DateTime.now(),
    });
  }

  onDeleted(String id) async {
    data.deleteOne(id);
  }

  void refresh() {
    notifyListeners();
  }
}
