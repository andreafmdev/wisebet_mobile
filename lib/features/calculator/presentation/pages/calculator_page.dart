import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../domain/models/offer.dart';
import '../../../../data/repositories/surebet_repository.dart';

class CalculatorPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? extra;

  const CalculatorPage({super.key, this.extra});

  @override
  ConsumerState<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends ConsumerState<CalculatorPage> {
  final _backOddsController = TextEditingController(text: '2.10');
  final _layOddsController = TextEditingController(text: '2.15');
  final _stakeController = TextEditingController(text: '100');
  SureBetCalculationResult? _result;

  @override
  void initState() {
    super.initState();
    if (widget.extra != null && widget.extra!['offer'] != null) {
      final offer = widget.extra!['offer'] as Offer;
      _stakeController.text = offer.bonusAmount.toStringAsFixed(0);
    }
    _calculate();
  }

  @override
  void dispose() {
    _backOddsController.dispose();
    _layOddsController.dispose();
    _stakeController.dispose();
    super.dispose();
  }

  void _calculate() {
    final backOdds = double.tryParse(_backOddsController.text) ?? 0;
    final layOdds = double.tryParse(_layOddsController.text) ?? 0;
    final stake = double.tryParse(_stakeController.text) ?? 0;

    if (backOdds > 0 && layOdds > 0 && stake > 0) {
      final surebetRepo = ref.read(surebetRepositoryProvider);
      setState(() {
        _result = surebetRepo.calculateSurebet(
          backOdds: backOdds,
          layOdds: layOdds,
          stake: stake,
        );
      });
    } else {
      setState(() {
        _result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcolatore SureBet'),
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
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inserisci i dati',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _backOddsController,
                      decoration: const InputDecoration(
                        labelText: 'Quota Back',
                        hintText: 'es. 2.10',
                        prefixIcon: Icon(Icons.trending_up),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculate(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _layOddsController,
                      decoration: const InputDecoration(
                        labelText: 'Quota Lay',
                        hintText: 'es. 2.15',
                        prefixIcon: Icon(Icons.trending_down),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculate(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _stakeController,
                      decoration: const InputDecoration(
                        labelText: 'Puntata (€)',
                        hintText: 'es. 100',
                        prefixIcon: Icon(Icons.euro),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculate(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_result != null) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Risultato',
                            style: AppTextStyles.h4,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _result!.isValid
                                  ? AppColors.success.withOpacity(0.2)
                                  : AppColors.error.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _result!.isValid ? 'Valida' : 'Non valida',
                              style: TextStyle(
                                color: _result!.isValid
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _ResultRow(
                        label: 'Puntata Back',
                        value: '€${_result!.backStake.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: 'Puntata Lay',
                        value: '€${_result!.layStake.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: 'Puntata Totale',
                        value: '€${_result!.totalStake.toStringAsFixed(2)}',
                      ),
                      const Divider(height: 24),
                      _ResultRow(
                        label: 'Profitto',
                        value: '€${_result!.profit.toStringAsFixed(2)}',
                        isHighlight: true,
                      ),
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: 'Rendimento',
                        value: '${_result!.profitPercentage.toStringAsFixed(2)}%',
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                AppCard(
                  child: Center(
                    child: Text(
                      'Inserisci i valori per calcolare',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _ResultRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isHighlight
              ? AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: isHighlight
              ? AppTextStyles.h4.copyWith(color: AppColors.accentGold)
              : AppTextStyles.bodyLarge,
        ),
      ],
    );
  }
}

