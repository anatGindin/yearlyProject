import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final ThemeData theme;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurfaceVariant,
        textDirection: TextDirection.ltr,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.outline,
      ),
      onTap: onTap,
    );
  }
}
