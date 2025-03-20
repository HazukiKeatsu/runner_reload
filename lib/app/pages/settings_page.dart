import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runner_reload/app/state/settings_state.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsState>();
    print("Settings in SettingsPage: ${settingsState.settings}"); // 添加调试日志

    return Scaffold(
      body:
          settingsState.settings.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView(
                children:
                    settingsState.settings.entries.map((entry) {
                      return ListTile(
                        title: Text(entry.key),
                        subtitle: Text(entry.value.toString()),
                      );
                    }).toList(),
              ),
    );
  }
}
