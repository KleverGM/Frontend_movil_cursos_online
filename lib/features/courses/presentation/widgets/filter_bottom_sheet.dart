import 'package:flutter/material.dart';
import '../../domain/entities/course_filters.dart';

/// Bottom sheet para filtrar cursos
class FilterBottomSheet extends StatefulWidget {
  final CourseFilters currentFilters;
  final Function(CourseFilters) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _categoria;
  late String? _nivel;
  late RangeValues _precioRange;
  late String? _ordenarPor;

  final List<String> _categorias = [
    'Programación',
    'Diseño',
    'Marketing',
    'Negocios',
    'Desarrollo Personal',
    'Fotografía',
    'Música',
  ];

  final List<String> _niveles = [
    'Principiante',
    'Intermedio',
    'Avanzado',
  ];

  final Map<String, String> _ordenOptions = {
    '-fecha_creacion': 'Más recientes',
    'fecha_creacion': 'Más antiguos',
    'precio': 'Menor precio',
    '-precio': 'Mayor precio',
    'titulo': 'A-Z',
    '-titulo': 'Z-A',
  };

  @override
  void initState() {
    super.initState();
    _categoria = widget.currentFilters.categoria;
    _nivel = widget.currentFilters.nivel;
    _precioRange = RangeValues(
      widget.currentFilters.precioMin ?? 0,
      widget.currentFilters.precioMax ?? 500,
    );
    _ordenarPor = widget.currentFilters.ordenarPor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtros',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Categoría
            _buildSectionTitle('Categoría'),
            _buildChipList(
              items: _categorias,
              selectedItem: _categoria,
              onSelected: (value) => setState(() => _categoria = value),
            ),
            const SizedBox(height: 20),

            // Nivel
            _buildSectionTitle('Nivel'),
            _buildChipList(
              items: _niveles,
              selectedItem: _nivel,
              onSelected: (value) => setState(() => _nivel = value),
            ),
            const SizedBox(height: 20),

            // Precio
            _buildSectionTitle('Rango de Precio'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  RangeSlider(
                    values: _precioRange,
                    min: 0,
                    max: 500,
                    divisions: 50,
                    labels: RangeLabels(
                      '\$${_precioRange.start.toStringAsFixed(0)}',
                      '\$${_precioRange.end.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) => setState(() => _precioRange = values),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_precioRange.start.toStringAsFixed(0)}'),
                      Text('\$${_precioRange.end.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ordenar por
            _buildSectionTitle('Ordenar por'),
            ..._ordenOptions.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: _ordenarPor,
                onChanged: (value) => setState(() => _ordenarPor = value),
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 20),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildChipList({
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selectedItem == item;
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            onSelected(selected ? item : null);
          },
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
          checkmarkColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }

  void _clearFilters() {
    setState(() {
      _categoria = null;
      _nivel = null;
      _precioRange = const RangeValues(0, 500);
      _ordenarPor = null;
    });
  }

  void _applyFilters() {
    final filters = CourseFilters(
      categoria: _categoria,
      nivel: _nivel,
      precioMin: _precioRange.start > 0 ? _precioRange.start : null,
      precioMax: _precioRange.end < 500 ? _precioRange.end : null,
      ordenarPor: _ordenarPor,
      searchQuery: widget.currentFilters.searchQuery,
    );
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }
}
