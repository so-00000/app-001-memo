import 'package:flutter/material.dart';

/// 設定画面（Darkモード専用）
class SettingsDark extends StatefulWidget {
  const SettingsDark({super.key});

  @override
  State<SettingsDark> createState() => _SettingsDarkState();
}

class _SettingsDarkState extends State<SettingsDark> {
  String _displayMode = 'auto';
  final List<Map<String, dynamic>> _statusList = [
    {'name': 'Done', 'color': const Color(0xFF00B894)},
    {'name': 'In Progress', 'color': const Color(0xFF4E94F8)},
    {'name': 'To Do', 'color': Colors.white},
  ];

  void _addStatus() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ステータス追加は今後実装予定です')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Display Mode =====
              const Text(
                'Display:',
                style: TextStyle(
                  color: Color(0xFFEBEBF5),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // 🌞🌙 Display Mode 切替ボタン
              Container(
                width: double.infinity, // 横幅をStatusバーと同じに
                decoration: BoxDecoration(
                  color: const Color(0xFF373739),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SegmentedButton<String>(
                  showSelectedIcon: false, // ✅ チェックマーク非表示
                  segments: [
                    ButtonSegment(
                      value: 'light',
                      label: Icon(
                        Icons.wb_sunny_outlined,
                        color: _displayMode == 'light'
                            ? Colors.black
                            : Colors.white,
                        size: 22,
                      ),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      label: Icon(
                        Icons.nightlight_round,
                        color:
                        _displayMode == 'dark' ? Colors.black : Colors.white,
                        size: 20,
                      ),
                    ),
                    ButtonSegment(
                      value: 'auto',
                      label: Text(
                        'auto',
                        style: TextStyle(
                          color: _displayMode == 'auto'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  selected: {_displayMode},
                  onSelectionChanged: (value) {
                    setState(() => _displayMode = value.first);
                  },
                  style: ButtonStyle(
                    // ✅ 枠線を消す！
                    side: WidgetStateProperty.all(BorderSide.none),

                    backgroundColor:
                    WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return const Color(0xFF373739);
                    }),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ===== Status =====
              const Text(
                'Status:',
                style: TextStyle(
                  color: Color(0xFFEBEBF5),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: [
                  for (final s in _statusList)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF373739),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: s['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            s['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: _addStatus,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF373739),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Color(0x99EBEBF5),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ===== Info =====
              const Text(
                'Info:',
                style: TextStyle(
                  color: Color(0xFFEBEBF5),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF373739),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edition : Free',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'ver 1.0.0 © xxxx',
                          style: TextStyle(
                            color: Color(0x99EBEBF5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.circle, color: Color(0xFF007AFF), size: 8),
                        SizedBox(width: 6),
                        Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
