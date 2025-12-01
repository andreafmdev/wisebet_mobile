import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../domain/models/profit_entry.dart';

class AddProfitEntryPage extends ConsumerStatefulWidget {
  const AddProfitEntryPage({super.key});

  @override
  ConsumerState<AddProfitEntryPage> createState() => _AddProfitEntryPageState();
}

class _AddProfitEntryPageState extends ConsumerState<AddProfitEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  ProfitType _selectedType = ProfitType.manual;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final profitRepo = ref.read(profitRepositoryProvider);

      final entry = ProfitEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _selectedDate,
        type: _selectedType,
        amount: amount,
        description: _descriptionController.text.trim(),
      );

      await profitRepo.addEntry(entry);

      if (mounted) {
        ErrorHandler.showSuccess(context, 'Operazione aggiunta con successo');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, 'Errore durante il salvataggio');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Operazione'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tipo Operazione',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ProfitType.values.map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(_getTypeLabel(type)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedType = type;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Importo (€)',
                    prefixIcon: Icon(Icons.euro),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un importo';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Importo non valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Inserisci una descrizione';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Data'),
                  subtitle: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _selectDate,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Salva',
                  onPressed: _isLoading ? null : _submit,
                  isLoading: _isLoading,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}

