import 'package:flutter/material.dart';

/// ===============================
/// 🎨 ステータスカラー マッピング
/// ===============================
///
/// DBの color_code に対応する実際の Color を定義。
/// '01','02' は固定（完了・未完了）
/// '11'〜'16' はユーザーカスタム候補。
///
const Map<String, Color> kStatusColorMapper = {
  // 固定ステータス
  '01': Color(0xFF2ECC71), // 完了（緑）
  '02': Color(0xFF95A5A6), // 未完了（グレー）

  // ユーザーカスタム候補（最大4色）
  '11': Color(0xFFE74C3C), // 赤
  '12': Color(0xFFF1C40F), // 黄
  '13': Color(0xFF3498DB), // 青
  '14': Color(0xFF9B59B6), // 紫
  // '15': Color(0xFF1ABC9C), // ティール
  // '16': Color(0xFF34495E), // ダークグレー
};

/// ===============================
/// 🎯 コードから Color を取得
/// ===============================
///
/// 不正コードやnullは自動で灰色にフォールバック。
///
Color getStatusColor(String? code) {
  if (code == null) return Colors.grey;
  return kStatusColorMapper[code] ?? Colors.grey;
}

/// ===============================
/// 🧩 色選択パレット（UI表示用）
/// ===============================
///
/// 新しいステータス作成ダイアログなどで使用。
///
final List<Map<String, dynamic>> kStatusColorPalette = [
  {'code': '11', 'color': kStatusColorMapper['11']},
  {'code': '12', 'color': kStatusColorMapper['12']},
  {'code': '13', 'color': kStatusColorMapper['13']},
  {'code': '14', 'color': kStatusColorMapper['14']},
  // {'code': '15', 'color': kStatusColorMapper['15']},
  // {'code': '16', 'color': kStatusColorMapper['16']},
];
