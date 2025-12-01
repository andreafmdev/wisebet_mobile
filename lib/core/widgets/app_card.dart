import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Card riutilizzabile con stile premium
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.shadows,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: backgroundColor == null ? AppGradients.cardGradient : null,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: shadows ?? AppShadows.medium,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        child: card,
      );
    }

    return card;
  }
}

