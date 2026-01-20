import 'package:equatable/equatable.dart';

/// Eventos del BLoC de estadísticas globales
abstract class GlobalStatsEvent extends Equatable {
  const GlobalStatsEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar las estadísticas globales
class LoadGlobalStatsEvent extends GlobalStatsEvent {
  const LoadGlobalStatsEvent();
}

/// Evento para refrescar las estadísticas globales
class RefreshGlobalStatsEvent extends GlobalStatsEvent {
  const RefreshGlobalStatsEvent();
}
