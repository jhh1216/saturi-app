import 'package:flutter/material.dart';

const Color kDanchungRed = Color(0xFF5B8DEF);
const Color kDanchungBlue = Color(0xFF2D3561);
const Color kDanchungGold = Color(0xFFFFB347);
const Color kCreamBg = Color(0xFFF8F9FA);

const List<Color> kRegionColors = [
  Color(0xFF5B8DEF), // 서울 — 블루
  Color(0xFFFF6B6B), // 부산 — 코랄
  Color(0xFF48C774), // 전라 — 그린
  Color(0xFFFFB347), // 충청 — 오렌지
  Color(0xFF3DB4E0), // 강원 — 스카이
  Color(0xFFAB7CEA), // 제주 — 퍼플
];

ThemeData buildAppTheme() {
  const bold = TextStyle(fontWeight: FontWeight.w700);
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kDanchungRed).copyWith(
      primary: kDanchungRed,
      secondary: kDanchungBlue,
      surface: kCreamBg,
    ),
    scaffoldBackgroundColor: kCreamBg,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w900),
      displayMedium: TextStyle(fontWeight: FontWeight.w900),
      headlineLarge: TextStyle(fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(fontWeight: FontWeight.w800),
      headlineSmall: TextStyle(fontWeight: FontWeight.w700),
      titleLarge: bold,
      titleMedium: bold,
      bodyLarge: TextStyle(fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontWeight: FontWeight.w500),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1A1A1A),
      surfaceTintColor: Colors.transparent,
    ),
  );
}
