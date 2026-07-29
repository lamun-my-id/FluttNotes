import 'dart:async';

import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/data/map_document.dart';

class RemindersProvider with ChangeNotifier {
  RemindersProvider(this.data) {
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

  Future<MapDocument?> save({
    String? id,
    required String title,
    required DateTime? date,
    required List<Map<String, dynamic>> content,
  }) async {
    if (!_hasContent(title, content)) return null;
    return id == null
        ? _insert(title: title, date: date, content: content)
        : onUpdate(id, title: title, date: date, content: content);
  }

  Future<void> onSave({
    String? id,
    required String title,
    required DateTime? date,
    required List<Map<String, dynamic>> content,
  }) async {
    if (id == null) {
      if (_hasContent(title, content)) {
        await _insert(title: title, date: date, content: content);
      }
    } else if (!_hasContent(title, content)) {
      await onDeleted(id);
    } else {
      await onUpdate(id, title: title, date: date, content: content);
    }
  }

  bool _hasContent(String title, List<Map<String, dynamic>> content) {
    return title.isNotEmpty ||
        content.any((item) => item['controller'].toString().isNotEmpty);
  }

  List<Object?> _encodeContent(List<Map<String, dynamic>> content) {
    return content
        .map(
          (item) => <String, Object?>{
            "controller": item["controller"].toString(),
            "checklist": item["checklist"] == true,
          },
        )
        .toList(growable: false);
  }

  Future<MapDocument> _insert({
    required String title,
    required DateTime? date,
    required List<Map<String, dynamic>> content,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    return data.insert(<String, Object?>{
      "title": title,
      "date": date?.toUtc().toIso8601String(),
      "content": _encodeContent(content),
      "createdAt": now,
      "updatedAt": now,
    });
  }

  Future<MapDocument> onUpdate(
    String id, {
    required String title,
    required DateTime? date,
    required List<Map<String, dynamic>> content,
  }) {
    return data.patch(id, <String, Object?>{
      "title": title,
      "date": date?.toUtc().toIso8601String(),
      "content": _encodeContent(content),
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
