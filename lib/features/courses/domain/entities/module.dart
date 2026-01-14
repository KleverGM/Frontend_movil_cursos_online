import 'package:equatable/equatable.dart';
import 'section.dart';

/// Entidad de módulo del dominio
class Module extends Equatable {
  final int id;
  final String titulo;
  final String? descripcion;
  final int orden;
  final int cursoId;
  final List<Section> secciones;

  const Module({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.orden,
    required this.cursoId,
    this.secciones = const [],
  });

  int get totalSecciones => secciones.length;
  
  int get duracionTotal {
    return secciones.fold(0, (sum, section) => sum + section.duracionMinutos);
  }

  @override
  List<Object?> get props => [id, titulo, descripcion, orden, cursoId, secciones];
}
