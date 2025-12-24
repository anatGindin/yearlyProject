import 'package:flutter/material.dart';

class SelectedMarker extends StatefulWidget {
  const SelectedMarker({super.key});

  @override
  State<SelectedMarker> createState() => _SelectedMarkerState();
}

class _SelectedMarkerState extends State<SelectedMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: 70, height: 70),
          Icon(Icons.location_on, color: Colors.black, size: 60),
          Icon(Icons.location_on, color: Colors.red, size: 40),
        ],
      ),
    );
  }
}
