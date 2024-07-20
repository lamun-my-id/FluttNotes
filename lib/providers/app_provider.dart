import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  bool isLoading = false;
  late DataLocal data;
  late DataItem appSetting;

  AppProvider() {
    isLoading = true;
    refresh();
    initialize();
  }

  List<Map<String, dynamic>> fontSizeOptions = [
    {"id": "Small", "value": 12},
    {"id": "Medium", "value": 14},
    {"id": "Large", "value": 16},
    {"id": "Huge", "value": 18}
  ];

  List<Map<String, dynamic>> sortOptions = [
    {"id": "By creation date (A~Z)", "value": "createdAt", "desc": false},
    {"id": "By creation date (Z~A)", "value": "createdAt", "desc": true},
    {"id": "By modification date (A~Z)", "value": "updatedAt", "desc": false},
    {"id": "By modification date (Z~A)", "value": "updatedAt", "desc": true},
    {"id": "By title (A~Z)", "value": "title", "desc": false},
    {"id": "By title (Z~A)", "value": "title", "desc": true},
  ];

  List<Map<String, dynamic>> sortType = [];

  Future<void> initialize() async {
    data = await DataLocal.create(
      "app",
      onRefresh: () => refresh(),
      // debugMode: true,
    );
    data.onRefresh = () {
      if (data.count < 1) {
      } else {
        appSetting = data.data.first;
      }
      refresh();
    };
    data.refresh();
    Future.delayed(const Duration(milliseconds: 250)).then((value) {
      if (data.count < 1) {
        data.insertOne({
          "fontSize": {"id": "Medium", "value": 14},
          "sort": {"id": "By modification date", "value": "#updatedAt"},
        });
      }
      refresh();
    });
    isLoading = false;
    refresh();
  }

  Future<void> changeFontSize(Map<String, dynamic> value) async {
    try {
      await data.updateOne(appSetting.id, value: {"fontSize": value});
      refresh();
    } catch (e) {
      //
    }
  }

  Future<void> changeSort(Map<String, dynamic> value) async {
    try {
      await data.updateOne(appSetting.id, value: {"sort": value});
      refresh();
    } catch (e) {
      //
    }
  }

  void refresh() {
    notifyListeners();
  }
}
