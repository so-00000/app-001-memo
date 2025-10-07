// lib/services/memo_service.dart
import '../db/memo_database.dart';
import '../models/memo.dart';

class MemoService {
  static Future<void> toggleStatus(Memo memo) async {
    final newStatus = memo.status == '完了' ? '未完了' : '完了';
    final updatedMemo = memo.copyWith(status: newStatus);
    await MemoDatabase.instance.updateMemo(updatedMemo);
  }
}
