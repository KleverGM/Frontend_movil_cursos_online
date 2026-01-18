/// Modelo de entrada para formularios de cursos
class CourseInput {
  final int? id; // null si es nuevo curso, int si es edición
  final String titulo;
  final String descripcion;
  final String categoria;
  final String nivel;
  final double precio;
  final String? imagenPath;
  final String? imagenUrl; // URL de imagen existente para edición

  const CourseInput({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.nivel,
    required this.precio,
    this.imagenPath,
    this.imagenUrl,
  });

  /// Constructor vacío para un nuevo curso
  const CourseInput.empty()
      : id = null,
        titulo = '',
        descripcion = '',
        categoria = 'programacion',
        nivel = 'principiante',
        precio = 0,
        imagenPath = null,
        imagenUrl = null;

  /// Constructor desde una entidad Course para edición
  factory CourseInput.fromCourse(dynamic course) {
    return CourseInput(
      id: course.id,
      titulo: course.titulo,
      descripcion: course.descripcion,
      categoria: course.categoria,
      nivel: course.nivel,
      precio: course.precio,
      imagenUrl: course.imagen,
    );
  }

  /// Copiar con cambios
  CourseInput copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    String? categoria,
    String? nivel,
    double? precio,
    String? imagenPath,
    String? imagenUrl,
  }) {
    return CourseInput(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      nivel: nivel ?? this.nivel,
      precio: precio ?? this.precio,
      imagenPath: imagenPath ?? this.imagenPath,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  /// Verificar si es un curso nuevo (modo creación)
  bool get isNew => id == null;

  /// Verificar si el formulario es válido
  bool get isValid {
    return titulo.trim().isNotEmpty &&
        descripcion.trim().isNotEmpty &&
        categoria.isNotEmpty &&
        nivel.isNotEmpty &&
        precio >= 0;
  }
}
