import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider per la lingua
class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super('it'); // it o en

  void setLocale(String locale) {
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  return LocaleNotifier();
});

