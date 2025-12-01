import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../domain/models/guide.dart';

class GuidesListPage extends ConsumerStatefulWidget {
  const GuidesListPage({super.key});

  @override
  ConsumerState<GuidesListPage> createState() => _GuidesListPageState();
}

class _GuidesListPageState extends ConsumerState<GuidesListPage> {
  GuideCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final guidesRepo = ref.watch(guidesRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: Column(
          children: [
            // Category filter
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FutureBuilder<List<GuideCategory>>(
                future: guidesRepo.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryChip(
                        label: 'Tutte',
                        isSelected: _selectedCategory == null,
                        onTap: () => setState(() => _selectedCategory = null),
                      ),
                      ...snapshot.data!.map((cat) => _CategoryChip(
                            label: _getCategoryLabel(cat),
                            isSelected: _selectedCategory == cat,
                            onTap: () => setState(() => _selectedCategory = cat),
                          )),
                    ],
                  );
                },
              ),
            ),

            // Guides list
            Expanded(
              child: FutureBuilder<List<Guide>>(
                future: guidesRepo.getGuides(category: _selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nessuna guida disponibile'),
                    );
                  }

                  final guides = snapshot.data!.where((g) {
                    if (g.isPremiumOnly && !(user?.isPremium ?? false)) {
                      return false;
                    }
                    return true;
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: guides.length,
                    itemBuilder: (context, index) {
                      final guide = guides[index];
                      return _GuideCard(
                        guide: guide,
                        onTap: () => context.push('/guides/${guide.id}'),
                      );
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

  String _getCategoryLabel(GuideCategory category) {
    switch (category) {
      case GuideCategory.introduction:
        return 'Introduzione';
      case GuideCategory.surebet:
        return 'SureBet';
      case GuideCategory.valuebet:
        return 'ValueBet';
      case GuideCategory.bankroll:
        return 'Bankroll';
      case GuideCategory.tools:
        return 'Strumenti';
      case GuideCategory.advanced:
        return 'Avanzato';
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
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

class _GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback onTap;

  const _GuideCard({
    required this.guide,
    required this.onTap,
  });

  String _getCategoryLabel(GuideCategory category) {
    switch (category) {
      case GuideCategory.introduction:
        return 'Introduzione';
      case GuideCategory.surebet:
        return 'SureBet';
      case GuideCategory.valuebet:
        return 'ValueBet';
      case GuideCategory.bankroll:
        return 'Bankroll';
      case GuideCategory.tools:
        return 'Strumenti';
      case GuideCategory.advanced:
        return 'Avanzato';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getCategoryLabel(guide.category),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.accentTeal,
                  ),
                ),
              ),
              if (guide.isPremiumOnly)
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
          const SizedBox(height: 12),
          Text(
            guide.title,
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Text(
            guide.description,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                '${guide.estimatedReadTime} min',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

