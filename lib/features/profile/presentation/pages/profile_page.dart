import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/locale_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              AppCard(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.accentGold,
                      child: Text(
                        (user?.name ?? 'G').substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: AppColors.darkNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Guest',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'guest@wisebet.com',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (user?.isPremium ?? false)
                            ? AppColors.accentGold.withOpacity(0.2)
                            : AppColors.textTertiary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (user?.isPremium ?? false) ? 'PREMIUM' : 'FREE',
                        style: TextStyle(
                          color: (user?.isPremium ?? false)
                              ? AppColors.accentGold
                              : AppColors.textTertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Subscription
              AppCard(
                onTap: () => context.push('/subscription'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.accentGold),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Abbonamento',
                              style: AppTextStyles.bodyLarge,
                            ),
                            Text(
                              (user?.isPremium ?? false)
                                  ? 'Premium Attivo'
                                  : 'Passa a Premium',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Settings
              AppCard(
                child: Column(
                  children: [
                    _SettingTile(
                      icon: Icons.dark_mode,
                      title: 'Tema Scuro',
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          ref.read(themeProvider.notifier).setDarkMode(value);
                        },
                      ),
                    ),
                    const Divider(),
                    _SettingTile(
                      icon: Icons.language,
                      title: 'Lingua',
                      trailing: DropdownButton<String>(
                        value: locale,
                        items: const [
                          DropdownMenuItem(value: 'it', child: Text('Italiano')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(localeProvider.notifier).setLocale(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Logout
              PrimaryButton(
                text: 'Esci',
                icon: Icons.logout,
                isOutlined: true,
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/auth/onboarding');
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accentGold),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: trailing,
    );
  }
}

