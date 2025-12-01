import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Chip per statistiche con icona e valore
class StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const StatChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.1) ?? AppColors.accentGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color?.withOpacity(0.3) ?? AppColors.accentGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color ?? AppColors.accentGold),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.h4.copyWith(
                  color: color ?? AppColors.accentGold,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

