import 'package:flutter/foundation.dart';

class SettingsState extends ChangeNotifier {
  Map<String, dynamic> _settings = {};

  Map<String, dynamic> get settings => _settings;

  void updateSettings(Map<String, dynamic> newSettings) {
    _settings = newSettings;
    notifyListeners();
  }
}
