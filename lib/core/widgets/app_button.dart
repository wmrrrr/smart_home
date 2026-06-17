import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final IconData? icon;

  @override
  Widget build(final BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
          label: Text(label),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(label),
      ),
    );
  }
}
