import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/course_repository.dart';
import 'global_stats_event.dart';
import 'global_stats_state.dart';

/// BLoC para manejar estadísticas globales de la plataforma
class GlobalStatsBloc extends Bloc<GlobalStatsEvent, GlobalStatsState> {
  final CourseRepository _repository;

  GlobalStatsBloc(this._repository) : super(const GlobalStatsInitial()) {
    on<LoadGlobalStatsEvent>(_onLoadGlobalStats);
    on<RefreshGlobalStatsEvent>(_onRefreshGlobalStats);
  }

  Future<void> _onLoadGlobalStats(
    LoadGlobalStatsEvent event,
    Emitter<GlobalStatsState> emit,
  ) async {
    emit(const GlobalStatsLoading());
    await _fetchStats(emit);
  }

  Future<void> _onRefreshGlobalStats(
    RefreshGlobalStatsEvent event,
    Emitter<GlobalStatsState> emit,
  ) async {
    // No emitir loading para no mostrar indicador de carga en refresh
    await _fetchStats(emit);
  }

  Future<void> _fetchStats(Emitter<GlobalStatsState> emit) async {
    final result = await _repository.getGlobalStats();

    result.fold(
      (failure) {
        emit(GlobalStatsError(failure.message));
      },
      (stats) {
        emit(GlobalStatsLoaded(stats));
      },
    );
  }
}
