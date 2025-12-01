import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../domain/models/offer.dart';

class OffersListPage extends ConsumerWidget {
  const OffersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final offersRepo = ref.watch(offersRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offerte'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: FutureBuilder<List<Offer>>(
          future: offersRepo.getOffers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Nessuna offerta disponibile'),
              );
            }

            final offers = snapshot.data!;
            final availableOffers = offers.where((o) {
              if (o.isPremiumOnly && !(user?.isPremium ?? false)) {
                return false;
              }
              return true;
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: availableOffers.length,
              itemBuilder: (context, index) {
                final offer = availableOffers[index];
                return _OfferListItem(
                  offer: offer,
                  onTap: () => context.push('/offers/${offer.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OfferListItem extends StatelessWidget {
  final Offer offer;
  final VoidCallback onTap;

  const _OfferListItem({
    required this.offer,
    required this.onTap,
  });

  String _getTypeLabel(OfferType type) {
    switch (type) {
      case OfferType.welcome:
        return 'Benvenuto';
      case OfferType.recurring:
        return 'Ricorrente';
      case OfferType.cashback:
        return 'Cashback';
      case OfferType.freebet:
        return 'Free Bet';
      case OfferType.reload:
        return 'Reload';
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.bookmaker,
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.title,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ],
                ),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTypeLabel(offer.type),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.accentTeal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '€${offer.bonusAmount.toStringAsFixed(0)}',
                style: AppTextStyles.h3.copyWith(color: AppColors.accentGold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            offer.description,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

