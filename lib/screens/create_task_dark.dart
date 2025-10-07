import 'package:flutter/material.dart';
import '../db/memo_database.dart';
import '../models/memo.dart';

/// メモ作成画面（旧 AddNewTaskDark）
class CreateTaskDark extends StatefulWidget {
  const CreateTaskDark({super.key});

  @override
  State<CreateTaskDark> createState() => _CreateTaskDarkState();
}

class _CreateTaskDarkState extends State<CreateTaskDark> {
  // 入力内容を管理するコントローラ
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: TaskInputArea(controller: _controller)),
            CreateMemoButton(controller: _controller),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // メモリリーク防止
    super.dispose();
  }
}

/// メモ入力欄
class TaskInputArea extends StatelessWidget {
  final TextEditingController controller;
  const TaskInputArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const InputDecoration(
                hintText: 'What do you need to do?',
                hintStyle: TextStyle(
                  color: Color(0x99EBEBF5),
                  fontSize: 18,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// メモ作成ボタン
class CreateMemoButton extends StatelessWidget {
  final TextEditingController controller;
  const CreateMemoButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          minimumSize: const Size(310, 56),
        ),
        onPressed: () async {
          final text = controller.text.trim();
          if (text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('メモ内容を入力してください'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: 70,
                  left: 16,
                  right: 16,
                ),
              ),
            );
            return;
          }

          await MemoDatabase.instance.insertMemo(
            Memo(
              content: text,
              status: MemoStatusList.values[0], // デフォルト「未完了」
              createdAt: DateTime.now(),
            ),
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('メモを保存しました！'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: 70,
                left: 16,
                right: 16,
              ),
            ),
          );

          controller.clear();
        },
        child: const Text(
          'メモを作成',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
