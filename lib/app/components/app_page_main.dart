import 'package:flutter/material.dart';
import 'package:runner_reload/app/pages/record_page.dart';

class AppPageMain extends StatelessWidget {
  final int pageIndex;

  final List pageMain = [
    RecordPage(),
    Center(
      child: Icon(
        Icons.arrow_upward_outlined,
        color: Colors.black12,
        size: 128,
      ),
    ),
    Center(
      child: Icon(Icons.settings_outlined, color: Colors.black12, size: 128),
    ),
  ];

  AppPageMain({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return pageMain.elementAt(pageIndex);
  }
}
