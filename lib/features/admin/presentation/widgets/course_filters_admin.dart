import 'package:flutter/material.dart';
import '../../../../core/config/theme_config.dart';

/// Widget de filtros para cursos del admin
class CourseFiltersAdmin extends StatefulWidget {
  final String? selectedCategoria;
  final String? selectedNivel;
  final bool? selectedActivo;
  final Function({
    String? categoria,
    String? nivel,
    bool? activo,
    String? search,
  }) onFiltersChanged;
  final VoidCallback onClearFilters;

  const CourseFiltersAdmin({
    super.key,
    this.selectedCategoria,
    this.selectedNivel,
    this.selectedActivo,
    required this.onFiltersChanged,
    required this.onClearFilters,
  });

  @override
  State<CourseFiltersAdmin> createState() => _CourseFiltersAdminState();
}

class _CourseFiltersAdminState extends State<CourseFiltersAdmin> {
  final _searchController = TextEditingController();
  String? _categoria;
  String? _nivel;
  bool? _activo;

  @override
  void initState() {
    super.initState();
    _categoria = widget.selectedCategoria;
    _nivel = widget.selectedNivel;
    _activo = widget.selectedActivo;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    widget.onFiltersChanged(
      categoria: _categoria,
      nivel: _nivel,
      activo: _activo,
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
    );
  }

  void _clearAll() {
    setState(() {
      _categoria = null;
      _nivel = null;
      _activo = null;
      _searchController.clear();
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Buscar curso...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
            onSubmitted: (_) => _applyFilters(),
          ),
          const SizedBox(height: 16),

          // Filtros en fila
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Filtro de Categoría
                _buildFilterChip(
                  label: 'Categoría',
                  value: _getCategoriaLabel(_categoria),
                  onTap: () => _showCategoriaDialog(),
                ),
                const SizedBox(width: 8),

                // Filtro de Nivel
                _buildFilterChip(
                  label: 'Nivel',
                  value: _getNivelLabel(_nivel),
                  onTap: () => _showNivelDialog(),
                ),
                const SizedBox(width: 8),

                // Filtro de Estado
                _buildFilterChip(
                  label: 'Estado',
                  value: _getActivoLabel(_activo),
                  onTap: () => _showActivoDialog(),
                ),
                const SizedBox(width: 8),

                // Botón limpiar filtros
                if (_categoria != null || _nivel != null || _activo != null)
                  OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Limpiar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final isActive = value != 'Todos';
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? ThemeConfig.primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? ThemeConfig.primaryColor : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : ThemeConfig.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoriaLabel(String? categoria) {
    if (categoria == null) return 'Todos';
    return {
          'programacion': 'Programación',
          'diseño': 'Diseño',
          'marketing': 'Marketing',
          'negocios': 'Negocios',
          'idiomas': 'Idiomas',
          'musica': 'Música',
          'fotografia': 'Fotografía',
          'otros': 'Otros',
        }[categoria] ??
        categoria;
  }

  String _getNivelLabel(String? nivel) {
    if (nivel == null) return 'Todos';
    return {
          'principiante': 'Principiante',
          'intermedio': 'Intermedio',
          'avanzado': 'Avanzado',
        }[nivel] ??
        nivel;
  }

  String _getActivoLabel(bool? activo) {
    if (activo == null) return 'Todos';
    return activo ? 'Activos' : 'Inactivos';
  }

  Future<void> _showCategoriaDialog() async {
    final categorias = [
      {'value': null, 'label': 'Todos'},
      {'value': 'programacion', 'label': 'Programación'},
      {'value': 'diseño', 'label': 'Diseño'},
      {'value': 'marketing', 'label': 'Marketing'},
      {'value': 'negocios', 'label': 'Negocios'},
      {'value': 'idiomas', 'label': 'Idiomas'},
      {'value': 'musica', 'label': 'Música'},
      {'value': 'fotografia', 'label': 'Fotografía'},
      {'value': 'otros', 'label': 'Otros'},
    ];

    final selected = await showDialog<String?>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Seleccionar Categoría'),
        children: categorias.map((cat) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, cat['value']),
            child: Text(cat['label'] as String),
          );
        }).toList(),
      ),
    );

    if (selected != null || selected == null) {
      setState(() => _categoria = selected);
      _applyFilters();
    }
  }

  Future<void> _showNivelDialog() async {
    final niveles = [
      {'value': null, 'label': 'Todos'},
      {'value': 'principiante', 'label': 'Principiante'},
      {'value': 'intermedio', 'label': 'Intermedio'},
      {'value': 'avanzado', 'label': 'Avanzado'},
    ];

    final selected = await showDialog<String?>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Seleccionar Nivel'),
        children: niveles.map((nivel) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, nivel['value']),
            child: Text(nivel['label'] as String),
          );
        }).toList(),
      ),
    );

    if (selected != null || selected == null) {
      setState(() => _nivel = selected);
      _applyFilters();
    }
  }

  Future<void> _showActivoDialog() async {
    final estados = [
      {'value': null, 'label': 'Todos'},
      {'value': true, 'label': 'Activos'},
      {'value': false, 'label': 'Inactivos'},
    ];

    final selected = await showDialog<bool?>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Seleccionar Estado'),
        children: estados.map((estado) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, estado['value']),
            child: Text(estado['label'] as String),
          );
        }).toList(),
      ),
    );

    if (selected != null || selected == null) {
      setState(() => _activo = selected);
      _applyFilters();
    }
  }
}
