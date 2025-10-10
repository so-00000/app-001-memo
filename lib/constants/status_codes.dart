/// ===============================
/// 🧭 ステータスコード定義
/// ===============================
///
/// 01, 02 はアプリ固定（削除・編集不可）
/// 03〜08 はユーザー自由設定枠
/// DBテーブル: status
/// カラム: color_code（文字列）
///
/// 利用例:
///   if (status.colorCode == kStatusDone) { ... }
///

/// ✅ 完了（固定）
const String kStatusDone = '01';

/// 🕓 未完了（固定）
const String kStatusNotDone = '02';

/// 🔧 ユーザー定義ステータス（編集可）
const String kStatusCustom1 = '11';
const String kStatusCustom2 = '12';
const String kStatusCustom3 = '13';
const String kStatusCustom4 = '14';


/// ===============================
/// 🏷️ 固定ステータス表示名
/// ===============================
///
/// UIや条件判定で利用する場合はこちらを参照。
///
const String kStatusNameDone = '完了';
const String kStatusNameNotDone = '未完了';

/// ===============================
/// 🧩 ステータス固定判定ヘルパー
/// ===============================
///
/// 指定した color_code が固定（削除・編集不可）か判定。
///
bool isFixedStatus(String colorCode) {
  return colorCode == kStatusDone || colorCode == kStatusNotDone;
}
