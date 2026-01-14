import 'package:equatable/equatable.dart';
import 'course.dart';
import 'module.dart';

/// Entidad de detalle de curso con módulos
class CourseDetail extends Equatable {
  final Course course;
  final List<Module> modulos;
  final bool inscrito;
  final double? progreso;

  const CourseDetail({
    required this.course,
    required this.modulos,
    this.inscrito = false,
    this.progreso,
  });

  @override
  List<Object?> get props => [course, modulos, inscrito, progreso];
}
