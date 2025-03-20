import 'package:flutter/material.dart';

class AppPageNavigator extends StatelessWidget {
  const AppPageNavigator({
    super.key,
    required this.index,
    required this.onItemTapped,
  });

  final int index;
  final Function(int) onItemTapped;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (int newIndex) => onItemTapped(newIndex),
      destinations: const <NavigationDestination>[
        NavigationDestination(icon: Icon(Icons.location_on), label: 'Record'),
        NavigationDestination(icon: Icon(Icons.arrow_upward), label: 'Reload'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
