import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 16,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
