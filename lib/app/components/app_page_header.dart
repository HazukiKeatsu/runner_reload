import 'package:flutter/material.dart';

class AppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  final int pageIndex;
  final Widget notice;

  const AppPageHeader({
    super.key,
    required this.pageIndex,
    required this.notice,
  });

  @override
  Size get preferredSize => Size.fromHeight(100);

  String getTitle(int index) {
    if (index == 0) {
      return "Record";
    } else if (index == 1) {
      return "Reload";
    } else {
      return "Settings";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(getTitle(pageIndex)), actions: [notice]);
  }
}
