import 'package:flutter/material.dart';
import 'package:simple_memo/screens/create_task_dark.dart';
import 'screens/create_task_dark.dart'; // ← 今作った画面をimport

void main() {
  runApp(const MyApp());
}

/// アプリ全体のルートWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 最初に表示する画面
      home: const CreateTaskDark(),

      // 今後画面を増やすときはここでルート名と紐付け
      routes: {
        // '/tasks': (context) => const TasksListDark(), ← 履歴画面を追加する時にここへ
      },

      // 共通テーマ設定（オプション）
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF007AFF),
          secondary: Color(0xFF1C1C1E),
        ),
      ),
    );
  }
}
