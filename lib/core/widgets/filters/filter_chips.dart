import 'package:flutter/material.dart';

/// Modelo para un filtro chip
class FilterOption {
  final String id;
  final String label;
  final IconData? icon;

  const FilterOption({
    required this.id,
    required this.label,
    this.icon,
  });
}

/// Widget reutilizable para lista de chips de filtro
class FilterChips extends StatelessWidget {
  final List<FilterOption> options;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const FilterChips({
    super.key,
    required this.options,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: options
            .map((option) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChipWidget(
                    label: option.label,
                    icon: option.icon,
                    isSelected: selectedFilter == option.id,
                    onSelected: () => onFilterChanged(option.id),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

/// Widget para un chip de filtro individual
class FilterChipWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }
}
