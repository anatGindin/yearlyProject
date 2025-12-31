import 'package:flutter/material.dart';

class MissionCardBase extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final dynamic color;
  final Color? statusColor;

  const MissionCardBase({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 220,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: color ?? Theme.of(context).cardColor,
          child: Stack(
            children: [
              if (statusColor != null)
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  start: 0,
                  top: 0,
                  bottom: 0,
                  width: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: statusColor,
                      boxShadow: [],
                    ),
                  ),
                ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 20,
                    bottom: 20,
                    start: 16,
                    end: 10,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
