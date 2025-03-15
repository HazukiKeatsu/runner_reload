import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({
    super.key,
    required this.title,
    required this.locationMessage,
    required this.updateLocationMessage,
  });

  final String title;
  final String locationMessage;
  final Function(String) updateLocationMessage;

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 检查位置服务是否启用
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      widget.updateLocationMessage("位置服务未启用");
      // 提示用户启用位置服务
      await Geolocator.openLocationSettings(); //需要修改
      return;
    }

    // 检查位置权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        widget.updateLocationMessage("位置权限被拒绝");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      widget.updateLocationMessage("位置权限被永久拒绝");
      return;
    }

    // 获取当前位置
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 3),
    );

    widget.updateLocationMessage("${position.latitude}, ${position.longitude}");
  }

  Future<void> _saveLocationToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/locations.json');

    List<Map<String, dynamic>> locations = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      locations = List<Map<String, dynamic>>.from(json.decode(contents));
    }

    final location = {
      'latitude': widget.locationMessage.split(', ')[0],
      'longitude': widget.locationMessage.split(', ')[1],
      'timestamp': DateTime.now().toIso8601String(),
    };

    locations.add(location);

    await file.writeAsString(json.encode(locations));
  }

  void _locationMessageClear() async {
    await _saveLocationToFile();
    widget.updateLocationMessage("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Location:'),
            Text(
              widget.locationMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FilledButton(
                onPressed: _getCurrentLocation,
                child: Icon(Icons.flag),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: _locationMessageClear,
                child: Icon(Icons.clear),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
