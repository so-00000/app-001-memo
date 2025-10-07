import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../db/memo_database.dart';
import '../services/memo_service.dart';
import '../utils/date_formatter.dart';
import '../utils/status_color_helper.dart';

/// 🪧 編集可能なメモカードWidget
/// - メモ内容を直接編集可能
/// - 丸アイコンで「未完了 ⇄ 完了」を切り替え
/// - ステータス変更時は更新日時を変更しない
class EditableTaskCard extends StatefulWidget {
  final Memo memo;
  final Function(String) onContentChanged;

  const EditableTaskCard({
    super.key,
    required this.memo,
    required this.onContentChanged,
  });

  @override
  State<EditableTaskCard> createState() => _EditableTaskCardState();
}

class _EditableTaskCardState extends State<EditableTaskCard> {
  late TextEditingController _controller;
  bool _isEditing = false;
  String? _status; // ← nullableで安全に扱う

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.memo.content);
    _status = widget.memo.status; // ← 初期化
  }

  @override
  void didUpdateWidget(covariant EditableTaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memo.content != widget.memo.content) {
      _controller.text = widget.memo.content;
    }
    if (oldWidget.memo.status != widget.memo.status) {
      _status = widget.memo.status;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ✅ ステータスをトグル（完了 ⇄ 未完了）
  Future<void> _toggleStatus() async {
    await MemoService.toggleStatus(widget.memo);
    setState(() => _status = _status == '完了' ? '未完了' : '完了');
  }


  @override
  Widget build(BuildContext context) {
    final currentStatus = _status ?? '未完了'; // ← fallback安全
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),

      // ステータス
      child: ListTile(
        leading: GestureDetector(
          onTap: _toggleStatus,
          child: Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: StatusColors.fill(currentStatus),
              border: Border.all(color: StatusColors.border(currentStatus)),

            ),
          ),
        ),

        // メモ本文
        title: _isEditing
            ? TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
          ),
          onSubmitted: (newText) => _saveIfChanged(newText),
        )
            : GestureDetector(
          onTap: () => setState(() => _isEditing = true),
          child: Text(
            widget.memo.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 更新日時
        subtitle: Text(
          formatDateTime(widget.memo.createdAt),
          style: const TextStyle(
            color: Color(0x99EBEBF5),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// ✅ 内容変更時にDB反映
  void _saveIfChanged(String newText) {
    FocusScope.of(context).unfocus();
    final trimmed = newText.trim();
    if (trimmed.isNotEmpty && trimmed != widget.memo.content) {
      widget.onContentChanged(trimmed);
    }
    setState(() => _isEditing = false);
  }
}
