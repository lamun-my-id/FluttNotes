import 'package:flutter/material.dart';
import 'package:datalocal/datalocal.dart';

class CategoriesProvider with ChangeNotifier {
  late DataLocal data;
  bool isLoading = false;
  List<DataItem> categories = [];
  Map<String, dynamic> sort = {"value": "updatedAt"};

  CategoriesProvider() {
    isLoading = true;
    refresh();
    initialize();
  }

  initialize() async {
    // print("object");
    data = await DataLocal.create(
      "categories",
      onRefresh: () => refresh(),
      // debugMode: true,
    );
    data.onRefresh = () async {
      categories = await data.find(
        sorts: [
          DataSort(
            key: DataKey(sort['value'], onKeyCatch: "createdAt"),
            desc: sort['desc'] ?? true,
          ),
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

  Future<DataItem?> save({String? id, required String name}) async {
    if (id != null) {
      if (name.isNotEmpty) {
        return await onUpdate(id, name: name);
      }
    } else {
      if (name.isNotEmpty) {
        return await data.insertOne({
          "name": name,
          "updatedAt": DateTime.now(),
        });
      }
    }
    return null;
  }

  onSave({String? id, required String name}) async {
    if (id != null) {
      if (name.isNotEmpty) {
        onUpdate(id, name: name);
      } else {
        onDeleted(id);
      }
    } else {
      if (name.isNotEmpty) {
        data.insertOne({
          "name": name,
          "updatedAt": DateTime.now(),
        });
      }
    }
  }

  onUpdate(String id, {required String name}) async {
    data.updateOne(id, value: {
      "name": name,
      "updatedAt": DateTime.now(),
    });
  }

  onDeleted(String id) async {
    data.deleteOne(id);
  }
}
