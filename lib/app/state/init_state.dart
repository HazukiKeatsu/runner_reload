import 'package:flutter/material.dart';

class InitState extends ChangeNotifier {
  bool isInitialized = false;
  String errorMessage = '';
  Map<String, bool> initializationItem = {
    "位置服务": true,
    "定位权限": true,
    "文件读写": true,
    "模拟定位权限": true,
  };

  void setInitialized(bool initialized, [String error = '']) {
    isInitialized = initialized;
    errorMessage = error;
    notifyListeners();
  }
}
