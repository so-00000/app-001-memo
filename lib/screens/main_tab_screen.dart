import 'package:flutter/material.dart';
import 'package:simple_memo/widgets/bottom_tab_bar.dart';
import '../widgets/header_bar.dart';
import 'create_task_dark.dart';
import 'tasks_list_dark.dart';
import 'settings_dark.dart';

/// 全体を管理するメイン画面
/// Flutterで言う「1つのActivityに複数Fragment構成」に相当
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  // 各タブに対応する画面
  final List<Widget> _screens = const [
    CreateTaskDark(),
    TasksListDark(),
    SettingsDark(),
  ];

  // タブ押下時にbodyを差し替え
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(),
            Expanded(child: _screens[_selectedIndex]),
            BottomTabBar(
              currentIndex: _selectedIndex,
              onTabSelected: _onTabTapped
            ),
          ],
        ),
      ),
    );
  }
}
