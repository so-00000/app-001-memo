// lib/models/memo.dart

class MemoStatusList {
  static const List<String> values = [
    '未完了',
    '人に依頼中',
    '完了',
  ];
}

// lib/models/memo.dart

class Memo {
  final int? id;
  final String content;
  final String status;
  final DateTime createdAt;

  Memo({
    this.id,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  // ← これを追加！
  Memo copyWith({
    int? id,
    String? content,
    String? status,
    DateTime? createdAt,
  }) {
    return Memo(
      id: id ?? this.id,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt, // ステータス変更時は触らない
    );
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'] as int?,
      content: map['content'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
