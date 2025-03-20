import 'package:flutter/material.dart';

class ProgramStatePointer extends StatelessWidget {
  final bool isInitialized;
  final Function() showBottomSheet;

  const ProgramStatePointer({
    super.key,
    required this.isInitialized,
    required this.showBottomSheet,
  });

  List<Widget> get stateList => [
    Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: showBottomSheet,
        child: Row(
          children: [
            Icon(Icons.fiber_smart_record),
            SizedBox(width: 8),
            Text("准备就绪"),
          ],
        ),
      ),
    ),
    Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: showBottomSheet,
        child: Row(
          children: [Icon(Icons.error), SizedBox(width: 8), Text("初始化失败")],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return stateList.elementAt(isInitialized ? 0 : 1);
  }
}
