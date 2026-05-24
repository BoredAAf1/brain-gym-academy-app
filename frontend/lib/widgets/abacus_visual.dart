import 'package:flutter/material.dart';

class AbacusVisual extends StatelessWidget {
  const AbacusVisual({
    super.key,
    required this.tens,
    required this.ones,
  });

  final int tens;
  final int ones;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8E2C5), Color(0xFFF2D2AA)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB88355), width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AbacusRod(label: 'T', value: tens, beadColor: const Color(0xFFE76F51)),
          const SizedBox(width: 16),
          AbacusRod(label: 'O', value: ones, beadColor: const Color(0xFF2A9D8F)),
        ],
      ),
    );
  }
}

class AbacusRod extends StatelessWidget {
  const AbacusRod({
    super.key,
    required this.label,
    required this.value,
    required this.beadColor,
  });

  final String label;
  final int value;
  final Color beadColor;

  @override
  Widget build(BuildContext context) {
    final hasTopBead = value >= 5;
    final activeBottomBeads = value >= 5 ? value - 5 : value;
    const rodHeight = 182.0;
    const beamY = 58.0;
    const beamHeight = 8.0;
    const topRestY = 8.0;
    const topActiveY = 38.0;
    const lowerBeadHeight = 16.0;
    const lowerBeadGap = 2.0;
    const lowerRestStartY = 82.0;
    const lowerLift = 12.0;

    return Column(
      children: [
        Text(label),
        const SizedBox(height: 8),
        SizedBox(
          width: 52,
          height: rodHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 6,
                height: rodHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF7F5539),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Positioned(
                top: beamY,
                child: Container(
                  width: 52,
                  height: beamHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C4434),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                top: hasTopBead ? topActiveY : topRestY,
                child: SorobanBead(active: hasTopBead, color: beadColor, width: 34, height: 16),
              ),
              ...List.generate(4, (index) {
                final isActive = index < activeBottomBeads;
                final restY = lowerRestStartY + (index * (lowerBeadHeight + lowerBeadGap));
                final activeY = restY - lowerLift;

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  top: isActive ? activeY : restY,
                  child: SorobanBead(active: isActive, color: beadColor, width: 34, height: 14),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class SorobanBead extends StatelessWidget {
  const SorobanBead({
    super.key,
    required this.active,
    required this.color,
    required this.width,
    required this.height,
  });

  final bool active;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fill = active ? color : color.withOpacity(0.22);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            fill.withOpacity(active ? 0.95 : 0.28),
            fill,
          ],
        ),
        border: Border.all(color: active ? color.withOpacity(0.95) : color.withOpacity(0.45)),
      ),
    );
  }
}
