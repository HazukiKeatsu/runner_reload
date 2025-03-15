import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.title, required this.outputPath});

  final String title;
  final String outputPath;
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/locations.json');

    if (await file.exists()) {
      final contents = await file.readAsString();
      setState(() {
        _locations = List<Map<String, dynamic>>.from(json.decode(contents));
      });
    }
  }

  Future<void> _clearAllMessage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/locations.json');

    if (await file.exists()) {
      await file.writeAsString(json.encode([])); // 清空文件内容
      setState(() {
        _locations = [];
      });
    }
  }

  Future<void> _outputMessageFile(String _outputPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/locations.json');

    if (await file.exists()) {
      final outputDirectory = Directory(_outputPath); // 指定导出位置
      if (!await outputDirectory.exists()) {
        await outputDirectory.create(recursive: true);
      }
      final outputFile = File('${outputDirectory.path}/locations.json');
      await file.copy(outputFile.path);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('文件已导出到 ${outputFile.path}')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('没有找到要导出的文件')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          final location = _locations[index];
          return ListTile(
            title: Text(
              'Latitude: ${location['latitude']}, Longitude: ${location['longitude']}',
            ),
            subtitle: Text('Timestamp: ${location['timestamp']}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => _outputMessageFile(widget.outputPath),
                child: Icon(Icons.output),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: _clearAllMessage,
                child: Icon(Icons.clear),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
