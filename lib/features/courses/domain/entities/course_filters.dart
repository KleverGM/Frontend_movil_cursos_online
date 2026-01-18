import 'package:equatable/equatable.dart';

/// Entidad para filtros y búsqueda de cursos
class CourseFilters extends Equatable {
  final String? searchQuery;
  final String? categoria;
  final String? nivel;
  final double? precioMin;
  final double? precioMax;
  final String? ordenarPor; // 'fecha_creacion', 'titulo', 'precio', '-fecha_creacion'

  const CourseFilters({
    this.searchQuery,
    this.categoria,
    this.nivel,
    this.precioMin,
    this.precioMax,
    this.ordenarPor,
  });

  /// Filtros vacíos (sin filtrar)
  const CourseFilters.empty()
      : searchQuery = null,
        categoria = null,
        nivel = null,
        precioMin = null,
        precioMax = null,
        ordenarPor = null;

  /// Verificar si hay algún filtro activo
  bool get hasActiveFilters =>
      searchQuery != null ||
      categoria != null ||
      nivel != null ||
      precioMin != null ||
      precioMax != null ||
      ordenarPor != null;

  /// Copiar con modificaciones
  CourseFilters copyWith({
    String? searchQuery,
    String? categoria,
    String? nivel,
    double? precioMin,
    double? precioMax,
    String? ordenarPor,
  }) {
    return CourseFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      categoria: categoria ?? this.categoria,
      nivel: nivel ?? this.nivel,
      precioMin: precioMin ?? this.precioMin,
      precioMax: precioMax ?? this.precioMax,
      ordenarPor: ordenarPor ?? this.ordenarPor,
    );
  }

  /// Limpiar todos los filtros
  CourseFilters clearAll() => const CourseFilters.empty();

  @override
  List<Object?> get props => [
        searchQuery,
        categoria,
        nivel,
        precioMin,
        precioMax,
        ordenarPor,
      ];
}
