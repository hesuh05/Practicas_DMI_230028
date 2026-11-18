import 'package:flutter/material.dart';

class CertificationBadge extends StatelessWidget {
  const CertificationBadge({super.key, required this.certification});

  final String certification;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          certification,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: colors.onSurface, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
