import 'package:flutter/material.dart';

/// Widget para mostrar calificación con estrellas
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color? color;
  final bool showValue;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 20,
    this.color,
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.amber;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(starCount, (index) {
          if (index < rating.floor()) {
            // Estrella completa
            return Icon(Icons.star, size: size, color: effectiveColor);
          } else if (index < rating) {
            // Media estrella
            return Icon(Icons.star_half, size: size, color: effectiveColor);
          } else {
            // Estrella vacía
            return Icon(Icons.star_border, size: size, color: effectiveColor);
          }
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
