import 'package:flutter/material.dart';

class DriverCardBase extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const DriverCardBase({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Padding(padding: const EdgeInsets.all(10.0), child: child),
          ),
        ),
      ),
    );
  }
}
