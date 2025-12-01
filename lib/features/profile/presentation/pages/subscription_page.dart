import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../domain/models/subscription_plan.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  String? _selectedPlanId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final subscriptionRepo = ref.watch(subscriptionRepositoryProvider);

    if (user?.isPremium ?? false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Abbonamento Premium'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
          child: Center(
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 64,
                    color: AppColors.accentGold,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sei già Premium!',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Il tuo abbonamento è attivo',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passa a Premium'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: FutureBuilder<List<SubscriptionPlan>>(
          future: subscriptionRepo.getPlans(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Errore nel caricamento'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 64,
                          color: AppColors.accentGold,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sblocca tutte le funzionalità',
                          style: AppTextStyles.h3,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ..._getBenefits().map((benefit) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style: AppTextStyles.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Scegli il tuo piano',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 16),
                  ...snapshot.data!.map((plan) => _PlanCard(
                        plan: plan,
                        isSelected: _selectedPlanId == plan.id,
                        onTap: () {
                          setState(() {
                            _selectedPlanId = plan.id;
                          });
                        },
                      )),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Sottoscrivi (Mock)',
                    icon: Icons.payment,
                    onPressed: _selectedPlanId == null || _isLoading
                        ? null
                        : () => _subscribe(_selectedPlanId!),
                    isLoading: _isLoading,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nota: Questo è un mock. Nessun pagamento reale verrà effettuato.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<String> _getBenefits() {
    return [
      'Accesso completo a tutti gli strumenti',
      'Guide avanzate esclusive',
      'Notifiche in tempo reale per surebet',
      'Supporto prioritario',
      'Statistiche dettagliate',
      'Report personalizzati',
    ];
  }

  Future<void> _subscribe(String planId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final subscriptionRepo = ref.read(subscriptionRepositoryProvider);
      final success = await subscriptionRepo.subscribeToPlan(planId);

      if (success && mounted) {
        // Upgrade user to premium
        final expiresAt = DateTime.now().add(const Duration(days: 30));
        ref.read(authProvider.notifier).upgradeToPremium(expiresAt);

        ErrorHandler.showSuccess(context, 'Abbonamento attivato!');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, 'Errore durante la sottoscrizione');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.accentGold : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.name,
                  style: AppTextStyles.h4,
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.accentGold),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '€${plan.price.toStringAsFixed(2)}',
              style: AppTextStyles.h2.copyWith(color: AppColors.accentGold),
            ),
            const SizedBox(height: 4),
            Text(
              'per ${plan.durationMonths} ${plan.durationMonths == 1 ? 'mese' : 'mesi'}',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            ...plan.benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

