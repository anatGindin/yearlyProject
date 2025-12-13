import 'package:flutter/material.dart';

class ListActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ListActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft),
      label: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}
