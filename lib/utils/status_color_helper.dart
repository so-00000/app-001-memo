// lib/theme/status_colors.dart
import 'package:flutter/material.dart';

class StatusColors {
  static Color fill(String status) {
    switch (status) {
      case '完了':
        return Colors.greenAccent;
      default:
        return Colors.black;
    }
  }

  static Color border(String status) {
    switch (status) {
      case '完了':
        return Colors.greenAccent;
      default:
        return Colors.white70;
    }
  }
}
