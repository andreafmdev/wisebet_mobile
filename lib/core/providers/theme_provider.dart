import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider per il tema (dark/light)
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(true); // true = dark, false = light

  void toggleTheme() {
    state = !state;
  }

  void setDarkMode(bool isDark) {
    state = isDark;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

