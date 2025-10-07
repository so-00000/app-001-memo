/// 📅 日付フォーマット系ユーティリティ
String formatDateTime(DateTime date) {
  final y = date.year;
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  final h = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '$y/$m/$d $h:$min';
}
