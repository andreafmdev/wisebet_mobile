import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/profit_chart_widget.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../domain/models/profit_entry.dart';

class ProfitTrackerPage extends ConsumerStatefulWidget {
  const ProfitTrackerPage({super.key});

  @override
  ConsumerState<ProfitTrackerPage> createState() => _ProfitTrackerPageState();
}

class _ProfitTrackerPageState extends ConsumerState<ProfitTrackerPage> {
  ProfitType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final profitRepo = ref.watch(profitRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Tracker'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final router = GoRouter.of(context);
                  await router.push('/profit-tracker/add');
                  setState(() {});
                },
              ),
            ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: Column(
          children: [
            // Filters
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: 'Tutti',
                    isSelected: _selectedFilter == null,
                    onTap: () => setState(() => _selectedFilter = null),
                  ),
                  ...ProfitType.values.map((type) => _FilterChip(
                        label: _getTypeLabel(type),
                        isSelected: _selectedFilter == type,
                        onTap: () => setState(() => _selectedFilter = type),
                      )),
                ],
              ),
            ),

            // Chart
            AppCard(
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.all(16),
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
                      startDate: DateTime.now().subtract(const Duration(days: 30)),
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

            // List
            Expanded(
              child: FutureBuilder<List<ProfitEntry>>(
                future: profitRepo.getEntries(type: _selectedFilter),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nessuna operazione registrata'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final entry = snapshot.data![index];
                      return _ProfitEntryItem(entry: entry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(ProfitType type) {
    switch (type) {
      case ProfitType.welcomeOffer:
        return 'Benvenuto';
      case ProfitType.recurringOffer:
        return 'Ricorrente';
      case ProfitType.surebet:
        return 'SureBet';
      case ProfitType.valuebet:
        return 'ValueBet';
      case ProfitType.manual:
        return 'Manuale';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.accentGold.withOpacity(0.3),
        checkmarkColor: AppColors.accentGold,
      ),
    );
  }
}

class _ProfitEntryItem extends StatelessWidget {
  final ProfitEntry entry;

  const _ProfitEntryItem({required this.entry});

  String _getTypeLabel(ProfitType type) {
    switch (type) {
      case ProfitType.welcomeOffer:
        return 'Bonus Benvenuto';
      case ProfitType.recurringOffer:
        return 'Offerta Ricorrente';
      case ProfitType.surebet:
        return 'SureBet';
      case ProfitType.valuebet:
        return 'ValueBet';
      case ProfitType.manual:
        return 'Manuale';
    }
  }

  IconData _getTypeIcon(ProfitType type) {
    switch (type) {
      case ProfitType.welcomeOffer:
        return Icons.card_giftcard;
      case ProfitType.recurringOffer:
        return Icons.repeat;
      case ProfitType.surebet:
        return Icons.trending_up;
      case ProfitType.valuebet:
        return Icons.analytics;
      case ProfitType.manual:
        return Icons.edit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = entry.amount >= 0;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isPositive ? AppColors.success : AppColors.error)
                  .withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTypeIcon(entry.type),
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTypeLabel(entry.type),
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  entry.description,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(entry.date),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}€${entry.amount.toStringAsFixed(2)}',
            style: AppTextStyles.h4.copyWith(
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

