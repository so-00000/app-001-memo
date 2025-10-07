import 'package:flutter/material.dart';
import 'screens/main_tab_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainTabScreen(), // ← 最初に起動する画面をこれにする
  ));
}
