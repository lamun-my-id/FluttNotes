import 'dart:async';

import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/data/map_document.dart';

class AppProvider with ChangeNotifier {
  AppProvider(this.data) {
    _initialize();
  }

  final DataLocalCollection<Map<String, Object?>> data;
  StreamSubscription<DataLocalQuerySnapshot<Map<String, Object?>>>?
  _subscription;
  bool isLoading = true;
  late MapDocument appSetting;

  final List<Map<String, dynamic>> fontSizeOptions = [
    {"id": "Small", "value": 12},
    {"id": "Medium", "value": 14},
    {"id": "Large", "value": 16},
    {"id": "Huge", "value": 18},
  ];

  final List<Map<String, dynamic>> sortOptions = [
    {"id": "By creation date (A~Z)", "value": "createdAt", "desc": false},
    {"id": "By creation date (Z~A)", "value": "createdAt", "desc": true},
    {"id": "By modification date (A~Z)", "value": "updatedAt", "desc": false},
    {"id": "By modification date (Z~A)", "value": "updatedAt", "desc": true},
    {"id": "By title (A~Z)", "value": "title", "desc": false},
    {"id": "By title (Z~A)", "value": "title", "desc": true},
  ];

  Future<void> _initialize() async {
    final snapshot = await data.query().get();
    appSetting = snapshot.documents.isEmpty
        ? await data.insert(<String, Object?>{
            "fontSize": <String, Object?>{"id": "Medium", "value": 14},
            "sort": <String, Object?>{
              "id": "By modification date (Z~A)",
              "value": "updatedAt",
              "desc": true,
            },
          })
        : snapshot.documents.first;
    _subscription = data.query().watch().listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        appSetting = snapshot.documents.first;
      }
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> changeFontSize(Map<String, dynamic> value) async {
    appSetting = await data.patch(appSetting.id, <String, Object?>{
      "fontSize": Map<String, Object?>.from(value),
    });
  }

  Future<void> changeSort(Map<String, dynamic> value) async {
    appSetting = await data.patch(appSetting.id, <String, Object?>{
      "sort": Map<String, Object?>.from(value),
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
