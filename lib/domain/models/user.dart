/// Modello utente
class User {
  final String id;
  final String email;
  final String? name;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final bool isGuest;

  User({
    required this.id,
    required this.email,
    this.name,
    this.isPremium = false,
    this.premiumExpiresAt,
    this.isGuest = false,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    bool? isGuest,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

