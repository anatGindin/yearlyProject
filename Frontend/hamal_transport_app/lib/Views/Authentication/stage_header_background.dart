import 'package:flutter/material.dart';

class StageHeaderBackground extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final double height;

  const StageHeaderBackground({
    super.key,
    required this.child,
    this.title,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content Layer (Bottom) - Allows scrolling behind the header
        child,

        // Stage Header Layer (Top) with theater-style effects
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF364678), Color(0xFF364678)],
                ),
                // Theater stage shadow effect
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: title,
                  ),
                ),
              ),
            ),
            // Glowing white thin line at the edge (theater spotlight effect)
            Container(
              height: 2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.7),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      168,
                      163,
                      163,
                    ).withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
