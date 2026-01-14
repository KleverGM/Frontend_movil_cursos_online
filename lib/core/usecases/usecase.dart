import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Clase base para use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> execute(Params params);
}

/// Para use cases sin parámetros
class NoParams {}
