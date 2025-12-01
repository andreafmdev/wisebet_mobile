import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../domain/models/offer.dart';

class OfferDetailPage extends ConsumerWidget {
  final String offerId;

  const OfferDetailPage({
    super.key,
    required this.offerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersRepo = ref.watch(offersRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Offerta'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: FutureBuilder<Offer?>(
          future: offersRepo.getOfferById(offerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Offerta non trovata'));
            }

            final offer = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.bookmaker,
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer.title,
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: AppGradients.accentGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bonus',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.darkNavy,
                                ),
                              ),
                              Text(
                                '€${offer.bonusAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descrizione',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer.description,
                          style: AppTextStyles.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requisiti',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 12),
                        ...offer.requirements.map((req) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      req,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Procedura',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 12),
                        ...offer.steps.asMap().entries.map((entry) {
                          final index = entry.key;
                          final step = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.accentGold,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: AppColors.darkNavy,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Apri Calcolatore',
                    icon: Icons.calculate,
                    onPressed: () {
                      context.push('/calculator', extra: {
                        'offer': offer,
                      });
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

