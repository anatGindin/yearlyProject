import 'package:flutter/material.dart';

class MissionCardBase extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final dynamic color;

  const MissionCardBase({
    super.key,
    required this.child,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 220,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          color: color ?? Theme.of(context).cardColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: 10,
                right: 10,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
