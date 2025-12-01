import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../domain/models/surebet.dart';

class SurebetsListPage extends ConsumerStatefulWidget {
  const SurebetsListPage({super.key});

  @override
  ConsumerState<SurebetsListPage> createState() => _SurebetsListPageState();
}

class _SurebetsListPageState extends ConsumerState<SurebetsListPage> {
  @override
  Widget build(BuildContext context) {
    final surebetRepo = ref.watch(surebetRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SureBet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: FutureBuilder<List<SureBet>>(
          future: surebetRepo.findSurebets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nessuna SureBet trovata',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Controlla di nuovo tra poco',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final surebet = snapshot.data![index];
                return _SurebetCard(surebet: surebet);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/calculator'),
        icon: const Icon(Icons.calculate),
        label: const Text('Calcolatore'),
      ),
    );
  }
}

class _SurebetCard extends StatelessWidget {
  final SureBet surebet;

  const _SurebetCard({required this.surebet});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${surebet.event.homeTeam} vs ${surebet.event.awayTeam}',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${surebet.event.sport} • ${surebet.event.league}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppGradients.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${surebet.profitPercentage.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const Text(
                      'Profitto',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.darkNavy,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OddsInfo(
                  label: 'Back',
                  bookmaker: surebet.backBookmaker,
                  odds: surebet.backOdds,
                  color: AppColors.accentTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OddsInfo(
                  label: 'Lay',
                  bookmaker: surebet.layBookmaker,
                  odds: surebet.layOdds,
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profitto atteso',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '€${surebet.profit.toStringAsFixed(2)}',
                  style: AppTextStyles.h4.copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OddsInfo extends StatelessWidget {
  final String label;
  final String bookmaker;
  final double odds;
  final Color color;

  const _OddsInfo({
    required this.label,
    required this.bookmaker,
    required this.odds,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            bookmaker,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            odds.toStringAsFixed(2),
            style: AppTextStyles.h4.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

