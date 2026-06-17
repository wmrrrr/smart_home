import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.name,
    required this.icon,
    required this.isActive,
    this.onTap,
  });

  final String name;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final onColor = isActive
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(80),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: onColor),
            const SizedBox(height: 8),
            Text(
              name,
              style: theme.textTheme.bodyMedium?.copyWith(color: onColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              isActive ? 'Увімкнено' : 'Вимкнено',
              style: theme.textTheme.labelSmall?.copyWith(color: onColor),
            ),
          ],
        ),
      ),
    );
  }
}
