import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>> loadSettings() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/settings.json'); // 确保路径一致
  if (await file.exists()) {
    final content = await file.readAsString();
    return jsonDecode(content);
  }
  throw "文件不存在";
}
