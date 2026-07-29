import 'dart:async';

import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/data/map_document.dart';

class NotesProvider with ChangeNotifier {
  NotesProvider(this.data) {
    _subscription = data.query().watch().listen((_) => notifyListeners());
  }

  final DataLocalCollection<Map<String, Object?>> data;
  StreamSubscription<DataLocalQuerySnapshot<Map<String, Object?>>>?
  _subscription;
  bool isLoading = false;
  Map<String, dynamic> sort = {"value": "updatedAt", "desc": true};
  Map<String, dynamic>? category;

  void changeSort(Map<String, dynamic> value) {
    sort = value;
    notifyListeners();
  }

  void changeCategory(Map<String, dynamic>? value) {
    category = value;
    notifyListeners();
  }

  Future<MapDocument?> save({
    String? id,
    required String title,
    required String content,
  }) async {
    if (title.isEmpty && content.isEmpty) return null;
    return id == null
        ? _insert(title: title, content: content)
        : onUpdate(id, title: title, content: content);
  }

  Future<void> onSave({
    String? id,
    required String title,
    required String content,
  }) async {
    if (id == null) {
      if (title.isNotEmpty || content.isNotEmpty) {
        await _insert(title: title, content: content);
      }
    } else if (title.isEmpty && content.isEmpty) {
      await onDeleted(id);
    } else {
      await onUpdate(id, title: title, content: content);
    }
  }

  Future<MapDocument> _insert({
    required String title,
    required String content,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    return data.insert(<String, Object?>{
      "title": title,
      "content": content,
      "createdAt": now,
      "updatedAt": now,
      "category": category == null
          ? null
          : Map<String, Object?>.from(category!),
    });
  }

  Future<MapDocument> onUpdate(
    String id, {
    required String title,
    required String content,
  }) {
    return data.patch(id, <String, Object?>{
      "title": title,
      "content": content,
      "updatedAt": DateTime.now().toUtc().toIso8601String(),
      "category": category == null
          ? null
          : Map<String, Object?>.from(category!),
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
