// lib/db/memo_database.dart

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/memo.dart'; // ← Memoモデルを使うため追加

class MemoDatabase {
  static final MemoDatabase instance = MemoDatabase._init();
  static Database? _database;

  MemoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('memos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Flutter公式推奨の保存先パスを取得
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE memos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        status TEXT NOT NULL,         -- ★ ステータス追加！
        created_at TEXT NOT NULL
      )
    ''');
  }

  /// 登録処理
  Future<int> insertMemo(Memo memo) async {
    final db = await instance.database;
    return await db.insert('memos', memo.toMap());
  }

  /// 一覧取得処理
  Future<List<Memo>> fetchAllMemos() async {
    final db = await instance.database;
    final result = await db.query('memos', orderBy: 'created_at DESC');
    return result.map((map) => Memo.fromMap(map)).toList();
  }

  /// 更新処理
  Future<int> updateMemo(Memo memo) async {
    final db = await instance.database;
    return db.update(
      'memos',
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  /// 削除処理
  Future<int> deleteMemo(int id) async {
    final db = await instance.database;
    return await db.delete(
      'memos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  Future close() async {
    final db = await _database;
    db?.close();
  }
}