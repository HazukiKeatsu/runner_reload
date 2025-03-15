import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:runner_reload/functions/data_cache.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.title,
    required this.outputPath,
    required this.updateOutputPath,
    required this.isDarkMode,
    required this.toggleDarkMode,
  });

  final String title;
  final String outputPath;
  final Function(String) updateOutputPath;
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/settings.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      final settings = json.decode(contents);
      if (settings.containsKey('OutputPath')) {
        widget.updateOutputPath(settings['OutputPath']);
      }
      if (settings.containsKey('DarkMode')) {
        widget.toggleDarkMode(settings['DarkMode'] as bool);
      }
    }
  }

  Future<void> _pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      widget.updateOutputPath(selectedDirectory);
      DataCache(
        dataKey: "OutputPath",
        dataValue: selectedDirectory,
      ).saveDataToFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('导出路径: \n${widget.outputPath}'),
              trailing: ElevatedButton(
                onPressed: _pickFolder,
                child: Text('选择文件夹'),
              ),
            ),
            ListTile(
              title: Text('暗色模式'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (bool value) {
                  widget.toggleDarkMode(value);
                  DataCache(
                    dataKey: "DarkMode",
                    dataValue: value.toString(),
                  ).saveDataToFile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
