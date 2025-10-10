import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  //
  // 🔌 DB接続
  //
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('memos.db');
    return _database!;
  }

  //
  // 🧱 初期化
  //
  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);
    return await openDatabase(
      path,
      version: 9, // ✅ version up！（8 → 9）
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  //
  // 🧩 テーブル作成
  //
  Future _createDB(Database db, int version) async {
    // ===============================
    // 🎨 ステータステーブル
    // ===============================
    await db.execute('''
      CREATE TABLE status (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color_code TEXT NOT NULL
      )
    ''');

    // ===============================
    // 🗒️ メモテーブル
    // ===============================
    await db.execute('''
      CREATE TABLE memos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        status_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT,                         -- ✅ 更新日時を追加！
        FOREIGN KEY (status_id) REFERENCES status(id)
      )
    ''');

    // ===============================
    // 🧩 初期データ登録（ステータス）
    // ===============================
    final initialStatuses = [
      {'name': '完了', 'color_code': '01'},   // ✅ 固定
      {'name': '未完了', 'color_code': '02'}, // ✅ 固定
    ];

    for (final status in initialStatuses) {
      await db.insert('status', status);
    }
  }

  //
  // 🔁 バージョンアップ時の再作成処理
  //
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // version 9 で updated_at 対応
    if (oldVersion < 9) {
      await db.execute('DROP TABLE IF EXISTS status');
      await db.execute('DROP TABLE IF EXISTS memos');
      await _createDB(db, newVersion);
    }
  }

  //
  // 🚪 クローズ処理
  //
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
