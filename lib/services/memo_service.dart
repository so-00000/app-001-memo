import '../db/dao/memo_dao.dart';
import '../db/database_helper.dart';
import '../models/memo.dart';

/// 💼 MemoService
/// アプリ全体のメモ操作を一元管理（DAO層との橋渡し）
///
/// ※ 今後Firebaseに移行しても、この層だけ差し替えれば済む構成。
class MemoService {
  final MemoDao _memoDao = MemoDao();

  /// ✏️ 新規登録
  Future<int> insertMemo(Memo memo) => _memoDao.insert(memo);

  /// 📜 一覧取得
  Future<List<Memo>> fetchAllMemos() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('''
    SELECT 
      m.id, 
      m.content, 
      m.status_id,
      m.created_at,
      m.updated_at,
      s.name AS status_name,
      s.color_code AS status_color
    FROM memos m
    LEFT JOIN status s ON m.status_id = s.id
    ORDER BY m.created_at DESC
  ''');

    // ✅ 修正ポイントここ！
    return result.map((row) => Memo.fromJoinedMap(row)).toList();
  }



  /// 🌀 ステータスをトグル（未完了 ⇄ 完了）
  Future<void> toggleStatus(Memo memo) async {
    final newStatusId = (memo.statusId == 3) ? 1 : 3;
    final updatedMemo = memo.copyWith(statusId: newStatusId);
    await _memoDao.update(updatedMemo);
  }

  /// 🎯 任意ステータスに更新（将来の設定画面対応）
  Future<void> updateStatus(int memoId, int newStatusId) async {
    final memos = await _memoDao.fetchAll();
    final target = memos.firstWhere((m) => m.id == memoId);
    final updated = target.copyWith(statusId: newStatusId);
    await _memoDao.update(updated);
  }

  /// 🧩 内容更新（本文変更など）
  Future<void> updateMemo(Memo memo) async {
    final updatedMemo = memo.copyWith(
      updatedAt: DateTime.now(), // ✅ 更新日時を今にする
    );
    await _memoDao.update(updatedMemo);
  }


  /// ❌ 削除
  Future<int> deleteMemo(int id) => _memoDao.delete(id);
}
