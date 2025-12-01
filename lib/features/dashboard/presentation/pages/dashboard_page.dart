import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_chip.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../../core/widgets/profit_chart_widget.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../domain/models/offer.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final profitRepo = ref.watch(profitRepositoryProvider);
    final offersRepo = ref.watch(offersRepositoryProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              // Refresh data
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ciao, ${user?.name ?? "Guest"}',
                              style: AppTextStyles.h2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dashboard',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () => context.push('/profile'),
                        ),
                      ],
                    ),
                  ),

                  // Stats cards
                  FutureBuilder<double>(
                    future: profitRepo.getTotalProfit(),
                    builder: (context, snapshot) {
                      return FutureBuilder<double>(
                        future: profitRepo.getMonthlyProfit(),
                        builder: (context, monthlySnapshot) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: StatChip(
                                    label: 'Profitto Totale',
                                    value: '€${(snapshot.data ?? 0).toStringAsFixed(2)}',
                                    icon: Icons.trending_up,
                                    color: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: StatChip(
                                    label: 'Questo Mese',
                                    value: '€${(monthlySnapshot.data ?? 0).toStringAsFixed(2)}',
                                    icon: Icons.calendar_today,
                                    color: AppColors.accentTeal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Profit chart
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Andamento Profitti',
                            style: AppTextStyles.h4,
                          ),
                        ),
                        FutureBuilder<Map<DateTime, double>>(
                          future: profitRepo.getProfitByDay(
                            startDate: DateTime.now().subtract(const Duration(days: 7)),
                            endDate: DateTime.now(),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              final data = snapshot.data!;
                              final profits = data.values.toList();
                              final labels = data.keys
                                  .map((d) => '${d.day}/${d.month}')
                                  .toList();
                              return ProfitChartWidget(
                                profits: profits,
                                labels: labels,
                                isLineChart: true,
                              );
                            }
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Quick actions
                  const SectionTitle(
                    title: 'Azioni Rapide',
                    subtitle: 'Accedi velocemente alle funzionalità principali',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.search,
                            label: 'Cerca SureBet',
                            color: AppColors.accentGold,
                            onTap: () => context.push('/surebets'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.calculate,
                            label: 'Calcolatore',
                            color: AppColors.accentTeal,
                            onTap: () => context.push('/calculator'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.book,
                            label: 'Guide',
                            color: AppColors.accentCyan,
                            onTap: () => context.push('/guides'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.local_offer,
                            label: 'Offerte',
                            color: AppColors.accentAmber,
                            onTap: () => context.push('/offers'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recommended offers
                  const SectionTitle(
                    title: 'Offerte Consigliate',
                    subtitle: 'Le migliori opportunità per te',
                  ),
                  FutureBuilder<List<Offer>>(
                    future: offersRepo.getRecommendedOffers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Nessuna offerta disponibile'),
                        );
                      }
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final offer = snapshot.data![index];
                            return _OfferCard(offer: offer);
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Offer offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: AppCard(
        onTap: () => context.push('/offers/${offer.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  offer.bookmaker,
                  style: AppTextStyles.h4,
                ),
                if (offer.isPremiumOnly)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PREMIUM',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              offer.title,
              style: AppTextStyles.bodyLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '€${offer.bonusAmount.toStringAsFixed(0)}',
              style: AppTextStyles.h3.copyWith(color: AppColors.accentGold),
            ),
          ],
        ),
      ),
    );
  }
}

