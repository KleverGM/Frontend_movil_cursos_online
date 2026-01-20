import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../courses/domain/entities/course.dart';
import '../repositories/admin_repository.dart';

/// Caso de uso para obtener todos los cursos como admin
class GetAllCoursesAdmin implements UseCase<List<Course>, GetAllCoursesParams> {
  final AdminRepository repository;

  GetAllCoursesAdmin(this.repository);

  @override
  Future<Either<Failure, List<Course>>> execute(GetAllCoursesParams params) async {
    return await repository.getAllCourses(
      categoria: params.categoria,
      nivel: params.nivel,
      search: params.search,
      activo: params.activo,
      instructorId: params.instructorId,
    );
  }

  Future<Either<Failure, List<Course>>> call(GetAllCoursesParams params) async {
    return execute(params);
  }
}

class GetAllCoursesParams {
  final String? categoria;
  final String? nivel;
  final String? search;
  final bool? activo;
  final int? instructorId;

  GetAllCoursesParams({
    this.categoria,
    this.nivel,
    this.search,
    this.activo,
    this.instructorId,
  });
}
