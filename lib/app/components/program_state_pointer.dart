import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runner_reload/app/state/init_state.dart';
import 'package:runner_reload/app/components/state_panel.dart';

class ProgramStatePointer extends StatelessWidget {
  const ProgramStatePointer({super.key});

  List<Widget> getStateList(BuildContext context, bool isInitialized) {
    final initializationItem =
        Provider.of<InitState>(context).initializationItem;

    return [
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed:
              () => showStateBottomSheet(
                context,
                "准备就绪",
                mapToWidgetList(initializationItem),
              ),
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
          onPressed:
              () => showStateBottomSheet(
                context,
                "初始化失败",
                mapToWidgetList(initializationItem),
              ),
          child: Row(
            children: [Icon(Icons.error), SizedBox(width: 8), Text("初始化失败")],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final initState = Provider.of<InitState>(context);
    return getStateList(
      context,
      initState.isInitialized,
    ).elementAt(initState.isInitialized ? 0 : 1);
  }
}
