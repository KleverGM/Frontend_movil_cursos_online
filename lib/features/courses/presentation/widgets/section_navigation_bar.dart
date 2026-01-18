import 'package:flutter/material.dart';
import '../../domain/entities/section.dart';

/// Widget de navegación entre secciones
class SectionNavigationBar extends StatelessWidget {
  final List<Section> sections;
  final int currentIndex;
  final ValueChanged<int> onSectionChanged;

  const SectionNavigationBar({
    super.key,
    required this.sections,
    required this.currentIndex,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón anterior
          ElevatedButton.icon(
            onPressed: currentIndex > 0
                ? () => onSectionChanged(currentIndex - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
            ),
          ),
          // Indicador de progreso
          Text(
            '${currentIndex + 1} / ${sections.length}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          // Botón siguiente
          ElevatedButton.icon(
            onPressed: currentIndex < sections.length - 1
                ? () => onSectionChanged(currentIndex + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Siguiente'),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }
}
