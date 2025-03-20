import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runner_reload/app/components/app_page_header.dart';
import 'package:runner_reload/app/components/app_page_main.dart';
import 'package:runner_reload/app/components/app_page_navigator.dart';
import 'package:runner_reload/app/components/program_state_pointer.dart';
import 'package:runner_reload/app/functions/init.dart';
import 'package:runner_reload/app/state/init_state.dart';
import 'package:runner_reload/app/state/settings_state.dart';
import 'package:runner_reload/app/functions/load_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = await loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InitState()),
        ChangeNotifierProvider(
          create: (_) => SettingsState()..updateSettings(settings),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  bool isInitialized = true;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    Init init = Init();
    final initState = Provider.of<InitState>(context, listen: false);

    try {
      await init.InitializeSettings(context); // 调用初始化设置
      await init.GetPermission(context);
      initState.setInitialized(true); // 初始化成功
    } catch (error) {
      initState.setInitialized(false, error as String); // 初始化失败
    }
  }

  void _onTapItem(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPageHeader(
        pageIndex: pageIndex,
        notice: const ProgramStatePointer(),
      ),
      body: AppPageMain(pageIndex: pageIndex),
      bottomNavigationBar: AppPageNavigator(
        index: pageIndex,
        onItemTapped: _onTapItem,
      ),
    );
  }
}
