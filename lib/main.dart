import 'package:flutter/material.dart';
import 'package:runner_reload/page/record_page.dart';
import 'package:runner_reload/page/history_page.dart';
import 'package:runner_reload/page/settings_page.dart';
import 'package:runner_reload/theme/default.dart';
import 'package:runner_reload/functions/data_cache.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _outputPath = "";
  late Future<void> _settingsFuture;

  @override
  void initState() {
    super.initState();
    _settingsFuture = _loadSettings();
  }

  Future<void> _loadSettings() async {
    final outputPath = await DataLoad(dataKey: "OutputPath").loadFileToData();
    final isDarkMode = await DataLoad(dataKey: "DarkMode").loadFileToData();

    setState(() {
      _outputPath = outputPath.toString();
      _isDarkMode = isDarkMode == 'true'; // 确保将字符串转换为布尔值
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    DataCache(
      dataKey: "DarkMode",
      dataValue: value.toString(),
    ).saveDataToFile(); // 将布尔值转换为字符串保存
  }

  void _updateOutputPath(String path) {
    setState(() {
      _outputPath = path;
    });
    DataCache(dataKey: "OutputPath", dataValue: path).saveDataToFile();
  }

  void _errorSolveInit() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/settings.json');

    file.delete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _settingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ); // 或者你可以返回一个加载页面
        } else if (snapshot.hasError) {
          if (snapshot.error.toString().contains(
            "FormatException: Unexpected character",
          )) {
            _errorSolveInit();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Text('Error: ${snapshot.error}'),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Home',
            theme: defaultTheme,
            darkTheme: darkTheme,
            themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: Framework(
              isDarkMode: _isDarkMode,
              toggleDarkMode: _toggleDarkMode,
              outputPath: _outputPath,
              updateOutputPath: _updateOutputPath,
            ),
          );
        }
      },
    );
  }
}

class Framework extends StatefulWidget {
  const Framework({
    super.key,
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.outputPath,
    required this.updateOutputPath,
  });

  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final String outputPath;
  final Function(String) updateOutputPath;

  @override
  State<Framework> createState() => _FrameworkState();
}

class _FrameworkState extends State<Framework> {
  int _selectedIndex = 0;
  String _locationMessage = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateLocationMessage(String message) {
    setState(() {
      _locationMessage = message;
    });
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Runner Record";
      case 1:
        return "History";
      case 2:
        return "Settings";
      default:
        return "Runner Reload";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          _getTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:
          _selectedIndex == 0
              ? RecordPage(
                title: "Record",
                locationMessage: _locationMessage,
                updateLocationMessage: _updateLocationMessage,
              )
              : _selectedIndex == 1
              ? HistoryPage(title: "History", outputPath: widget.outputPath)
              : SettingsPage(
                title: "Setting",
                outputPath: widget.outputPath,
                updateOutputPath: widget.updateOutputPath,
                isDarkMode: widget.isDarkMode,
                toggleDarkMode: widget.toggleDarkMode,
              ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
