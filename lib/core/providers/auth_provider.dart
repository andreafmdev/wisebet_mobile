import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user.dart';

/// Provider per l'autenticazione (mock)
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock: accetta qualsiasi credenziale
    state = User(
      id: '1',
      email: email,
      name: email.split('@').first,
      isPremium: false,
      isGuest: false,
    );
    return true;
  }

  Future<void> loginAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = User(
      id: 'guest_1',
      email: 'guest@wisebet.com',
      name: 'Guest',
      isPremium: false,
      isGuest: true,
    );
  }

  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    state = User(
      id: '2',
      email: email,
      name: name,
      isPremium: false,
      isGuest: false,
    );
    return true;
  }

  void logout() {
    state = null;
  }

  void upgradeToPremium(DateTime expiresAt) {
    if (state != null) {
      state = state!.copyWith(
        isPremium: true,
        premiumExpiresAt: expiresAt,
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

