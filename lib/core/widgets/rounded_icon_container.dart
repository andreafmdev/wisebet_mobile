import 'package:flutter/material.dart';

/// Container per icone con corner-shape round (stile Apple)
/// Simula il CSS corner-shape: round - angoli arrotondati morbidi
class RoundedIconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double? iconSize;
  final Color? backgroundColor;

  const RoundedIconContainer({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
    this.iconSize,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Corner-shape round: angoli arrotondati al ~30% del size (stile Apple)
    // Questo crea un rettangolo con angoli molto arrotondati, non circolare
    final borderRadius = size * 0.3;
    final bgColor = backgroundColor ?? color.withOpacity(0.15);
    final iSize = iconSize ?? (size * 0.5);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: iSize,
      ),
    );
  }
}

