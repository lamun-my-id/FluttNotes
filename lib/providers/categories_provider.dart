import 'dart:async';

import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/data/map_document.dart';

class CategoriesProvider with ChangeNotifier {
  CategoriesProvider(this.data) {
    _subscription = data.query().watch().listen((_) => notifyListeners());
  }

  final DataLocalCollection<Map<String, Object?>> data;
  StreamSubscription<DataLocalQuerySnapshot<Map<String, Object?>>>?
  _subscription;
  bool isLoading = false;
  Map<String, dynamic> sort = {"value": "updatedAt", "desc": true};

  void changeSort(Map<String, dynamic> value) {
    sort = value;
    notifyListeners();
  }

  Future<MapDocument?> save({String? id, required String name}) async {
    if (name.isEmpty) return null;
    return id == null ? _insert(name) : onUpdate(id, name: name);
  }

  Future<void> onSave({String? id, required String name}) async {
    if (id == null) {
      if (name.isNotEmpty) await _insert(name);
    } else if (name.isEmpty) {
      await onDeleted(id);
    } else {
      await onUpdate(id, name: name);
    }
  }

  Future<MapDocument> _insert(String name) {
    final now = DateTime.now().toUtc().toIso8601String();
    return data.insert(<String, Object?>{
      "name": name,
      "createdAt": now,
      "updatedAt": now,
    });
  }

  Future<MapDocument> onUpdate(String id, {required String name}) {
    return data.patch(id, <String, Object?>{
      "name": name,
      "updatedAt": DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> onDeleted(String id) async {
    await data.delete(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
