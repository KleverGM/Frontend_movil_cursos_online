import 'package:equatable/equatable.dart';
import '../../domain/entities/global_stats.dart';

/// Estados del BLoC de estadísticas globales
abstract class GlobalStatsState extends Equatable {
  const GlobalStatsState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class GlobalStatsInitial extends GlobalStatsState {
  const GlobalStatsInitial();
}

/// Estado de carga
class GlobalStatsLoading extends GlobalStatsState {
  const GlobalStatsLoading();
}

/// Estado cuando las estadísticas se cargaron exitosamente
class GlobalStatsLoaded extends GlobalStatsState {
  final GlobalStats stats;

  const GlobalStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

/// Estado de error
class GlobalStatsError extends GlobalStatsState {
  final String message;

  const GlobalStatsError(this.message);

  @override
  List<Object?> get props => [message];
}
