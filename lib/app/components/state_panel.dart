import 'package:flutter/material.dart';

List<Widget> mapToWidgetList(Map<String, bool> map) {
  return map.entries.map((entry) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(entry.key, style: const TextStyle(fontSize: 16)),
            Icon(
              entry.value ? Icons.check_circle : Icons.cancel,
              color: entry.value ? Colors.green : Colors.red,
            ),
          ],
        ),
        SizedBox(height: 12.0),
      ],
    );
  }).toList();
}

void showStateBottomSheet(
  BuildContext context,
  String title,
  List<Widget> content,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ...content,
              ElevatedButton(
                child: Text('关闭'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
