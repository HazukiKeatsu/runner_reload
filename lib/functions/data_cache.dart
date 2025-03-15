import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataCache {
  const DataCache({required this.dataKey, required this.dataValue});

  final String dataKey;
  final dynamic dataValue;

  Future<void> saveDataToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/settings.json');

    Map<String, dynamic> settings = {};
    if (await file.exists()) {
      final contents = await file.readAsString();
      settings = json.decode(contents);
    }

    settings[dataKey] = dataValue;

    await file.writeAsString(json.encode(settings));
  }
}

class DataLoad {
  const DataLoad({required this.dataKey});

  final String dataKey;

  Future<dynamic> loadFileToData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/settings.json');

    if (await file.exists()) {
      final contents = await file.readAsString();
      final settings = json.decode(contents);
      if (settings.containsKey(dataKey)) {
        return settings[dataKey];
      }
    }
    return null;
  }
}
