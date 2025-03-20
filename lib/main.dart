import 'package:flutter/material.dart';
import 'package:runner_reload/app/components/app_page_header.dart';
import 'package:runner_reload/app/components/app_page_main.dart';
import 'package:runner_reload/app/components/app_page_navigator.dart';
import 'package:runner_reload/app/components/program_state_pointer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Runner Reload',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;
  bool isInitialized = true;

  void _onTapItem(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('底部弹窗内容', style: TextStyle(fontSize: 20.0)),
              ElevatedButton(
                child: const Text('关闭'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPageHeader(
        pageIndex: pageIndex,
        notice: ProgramStatePointer(
          isInitialized: isInitialized,
          showBottomSheet: _showBottomSheet,
        ),
      ),
      body: AppPageMain(pageIndex: pageIndex),
      bottomNavigationBar: AppPageNavigator(
        index: pageIndex,
        onItemTapped: _onTapItem,
      ),
    );
  }
}
