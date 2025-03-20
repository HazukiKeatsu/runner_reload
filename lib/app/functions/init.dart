import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runner_reload/app/state/init_state.dart';
import 'package:runner_reload/app/functions/load_settings.dart';
import 'package:runner_reload/app/state/settings_state.dart';

import 'package:runner_reload/app/data/default_settings.dart';

class Init {
  Future<void> InitializeSettings(BuildContext context) async {
    final initState = Provider.of<InitState>(context, listen: false);

    String path;
    try {
      path = await _getAndroidDocumentDirectory();
    } catch (error) {
      print("获取文件目录失败：$error");
      initState.initializationItem["文件读写"] = false;
      throw '获取文件目录失败：$error';
    }

    if (path == '') {
      initState.initializationItem["文件读写"] = false;
      throw '获取文档目录时发生错误';
    }

    DefaultSettings ds = DefaultSettings();
    String settingsFilePath = "$path/settings.json";

    // 检查文件是否存在
    if (await _isFileExists(settingsFilePath)) {
      print("settings.json 文件已存在，跳过写入操作。");
    } else {
      print("settings.json 文件不存在，正在写入默认设置...");
      await _writeDefaultSettingsToDisk(settingsFilePath, ds.defaultSettings);
    }

    final settings = await loadSettings();
    print("Loaded settings: $settings"); // 添加调试日志
    context.read<SettingsState>().updateSettings(settings);
    print("Settings updated in SettingsState");
  }

  Future<void> GetPermission(BuildContext context) async {
    final initState = Provider.of<InitState>(context, listen: false);

    bool serviceEnabled;
    LocationPermission permission;

    // 检查定位服务是否启用
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      initState.initializationItem["位置服务"] = false;
      throw '定位服务未启用，请启用定位服务后重试。';
    }

    // 检查应用的定位权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 请求权限
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        initState.initializationItem["定位权限"] = false;
        throw '定位权限被拒绝，请授予权限后重试。';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 用户永久拒绝权限
      initState.initializationItem["定位权限"] = false;
      throw '定位权限被永久拒绝，请前往设置手动授予权限。';
    }

    print("定位权限已获取");
  }

  // 获取程序默认路径
  Future<String> _getAndroidDocumentDirectory() async {
    try {
      // 获取文档目录
      final Directory? directory = await getApplicationDocumentsDirectory();
      return directory?.path ?? '';
    } catch (e) {
      print("获取文档目录时发生错误: $e");
      return '';
    }
  }

  // 检查文件是否存在
  Future<bool> _isFileExists(String filePath) async {
    try {
      File file = File(filePath);
      return await file.exists();
    } catch (e) {
      print("检查文件是否存在时发生错误: $e");
      return false;
    }
  }

  // 写入默认设置信息到硬盘
  Future<void> _writeDefaultSettingsToDisk(
    String filePath,
    Map settings,
  ) async {
    try {
      // 将默认设置转换为 JSON 字符串
      String jsonString = jsonEncode(settings);

      // 创建文件对象
      File file = File(filePath);

      // 写入 JSON 数据到文件
      await file.writeAsString(jsonString);

      print("默认设置信息已成功写入到 $filePath");
    } catch (e) {
      print("写入默认设置信息时发生错误: $e");
    }
  }
}
