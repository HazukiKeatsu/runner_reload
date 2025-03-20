import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});
  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool isStarted = false;

  void startAndPause() {
    setState(() {
      isStarted = !isStarted;
    });
  }

  void stop() {
    setState(() {
      isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 12.0,
          left: 16.0,
          right: 16.0,
        ), // 调整按钮与底部的距离
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: startAndPause,
                child: isStarted ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: stop,
                child: const Icon(Icons.stop),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
