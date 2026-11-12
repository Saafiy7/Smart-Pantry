import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 24), const SizedBox(width: 8)],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );

    if (isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: AppColors.primaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: content,
      );
    }

    // Primary button: its style comes from filledButtonTheme in app_theme.dart
    return FilledButton(onPressed: onPressed, child: content);
  }
}
