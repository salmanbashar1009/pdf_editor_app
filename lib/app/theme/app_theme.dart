import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primary = Color(0xFF1565C0);
  static const _background = Color(0xFFF5F7FA);
  static const _surface = Colors.white;
  static const _text = Color(0xFF1A1A1A);
  static const _mutedText = Color(0xFF6B7280);
  static const _border = Color(0xFFE5E7EB);
  static const _success = Color(0xFF059669);
  static const _error = Color(0xFFDC2626);
  static const _warning = Color(0xFFD97706);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      surface: _surface,
      error: _error,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _surface,
        foregroundColor: _text,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _border),
        ),
        color: _surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _border),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700, color: _text),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: _text),
        bodyLarge: TextStyle(color: _text),
        bodyMedium: TextStyle(color: _text),
        bodySmall: TextStyle(color: _mutedText),
      ),
      dividerTheme: const DividerThemeData(color: _border),
      sliderTheme: SliderThemeData(
        activeTrackColor: _primary,
        thumbColor: _primary,
        overlayColor: _primary.withValues(alpha: 0.12),
      ),
    );
  }

  // Semantic accessors for feature widgets if needed.
  static Color get success => _success;
  static Color get warning => _warning;
  static Color get mutedText => _mutedText;
  static Color get border => _border;
}
