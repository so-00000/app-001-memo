import 'package:flutter/material.dart';
import '../db/memo_database.dart';
import '../models/memo.dart';
import '../widgets/memo_search_bar.dart';
import '../widgets/editable_task_card.dart';

class TasksListDark extends StatefulWidget {
  const TasksListDark({super.key});

  @override
  State<TasksListDark> createState() => _TasksListDarkState();
}

class _TasksListDarkState extends State<TasksListDark> {
  final TextEditingController _searchController = TextEditingController();
  List<Memo> _memos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final memos = await MemoDatabase.instance.fetchAllMemos();
    setState(() {
      _memos = memos;
      _isLoading = false;
    });
  }

  Future<void> _updateMemoContent(Memo memo, String newContent) async {
    final updated = Memo(
      id: memo.id,
      content: newContent,
      status: memo.status,
      createdAt: memo.createdAt,
    );
    await MemoDatabase.instance.updateMemo(updated);
    await _loadMemos();
  }

  Future<void> _deleteMemo(BuildContext context, Memo memo) async {
    // 🔴 一旦削除
    await MemoDatabase.instance.deleteMemo(memo.id!);
    setState(() {
      _memos.removeWhere((m) => m.id == memo.id);
    });

    // 🔁 SnackBar + Undo ボタンを表示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('メモを削除しました'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '元に戻す',
          textColor: Colors.white,
          onPressed: () async {
            // 👇 Undo時に再登録
            await MemoDatabase.instance.insertMemo(memo);
            await _loadMemos(); // 再描画
          },
        ),
      ),
    );
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        // ✅ ScaffoldMessenger は外に1つだけ！
        child: Builder(
          builder: (innerContext) => Column(
            children: [
              MemoSearchBar(
                controller: _searchController,
                onSearch: (query) async {
                  final all = await MemoDatabase.instance.fetchAllMemos();
                  setState(() {
                    _memos = all
                        .where((m) => m.content
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
              Expanded(child: _buildMemoList(innerContext)), // ✅ innerContext を渡す
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemoList(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_memos.isEmpty) {
      return const Center(
        child: Text(
          'まだメモがありません',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMemos,
      color: Colors.blueAccent,
      child: ListView.builder(
        itemCount: _memos.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final memo = _memos[index];
          return Dismissible(
            key: ValueKey(memo.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            onDismissed: (direction) => _deleteMemo(context, memo),
            child: EditableTaskCard(
              memo: memo,
              onContentChanged: (newText) => _updateMemoContent(memo, newText),
            ),
          );
        },
      ),
    );
  }
}
