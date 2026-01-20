import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/usecases/get_global_trends.dart';
import '../../domain/usecases/get_instructor_rankings.dart';
import '../../domain/usecases/get_popular_courses.dart';
import '../../domain/usecases/get_user_growth.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetPopularCoursesUseCase _getPopularCoursesUseCase;
  final GetGlobalTrendsUseCase _getGlobalTrendsUseCase;
  final GetInstructorRankingsUseCase _getInstructorRankingsUseCase;
  final GetUserGrowthUseCase _getUserGrowthUseCase;

  AnalyticsBloc(
    this._getPopularCoursesUseCase,
    this._getGlobalTrendsUseCase,
    this._getInstructorRankingsUseCase,
    this._getUserGrowthUseCase,
  ) : super(AnalyticsInitial()) {
    on<GetPopularCoursesEvent>(_onGetPopularCourses);
    on<GetGlobalTrendsEvent>(_onGetGlobalTrends);
    on<GetInstructorRankingsEvent>(_onGetInstructorRankings);
    on<GetUserGrowthEvent>(_onGetUserGrowth);
    on<RefreshAllAnalyticsEvent>(_onRefreshAllAnalytics);
  }

  Future<void> _onGetPopularCourses(
    GetPopularCoursesEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _getPopularCoursesUseCase.execute(event.days);
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (courses) => emit(PopularCoursesLoaded(courses)),
    );
  }

  Future<void> _onGetGlobalTrends(
    GetGlobalTrendsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _getGlobalTrendsUseCase.execute(event.days);
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (trends) => emit(GlobalTrendsLoaded(trends)),
    );
  }

  Future<void> _onGetInstructorRankings(
    GetInstructorRankingsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _getInstructorRankingsUseCase.execute(NoParams());
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (instructors) => emit(InstructorRankingsLoaded(instructors)),
    );
  }

  Future<void> _onGetUserGrowth(
    GetUserGrowthEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _getUserGrowthUseCase.execute(event.days);
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (growth) => emit(UserGrowthLoaded(growth)),
    );
  }

  Future<void> _onRefreshAllAnalytics(
    RefreshAllAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final coursesResult = await _getPopularCoursesUseCase.execute(event.days);
    final trendsResult = await _getGlobalTrendsUseCase.execute(event.days);
    final instructorsResult = await _getInstructorRankingsUseCase.execute(NoParams());
    final growthResult = await _getUserGrowthUseCase.execute(event.days);

    // Check if any failed
    if (coursesResult.isLeft() ||
        trendsResult.isLeft() ||
        instructorsResult.isLeft() ||
        growthResult.isLeft()) {
      // Get the first error message
      final error = coursesResult.fold(
        (failure) => failure.message,
        (_) => trendsResult.fold(
          (failure) => failure.message,
          (_) => instructorsResult.fold(
            (failure) => failure.message,
            (_) => growthResult.fold(
              (failure) => failure.message,
              (_) => 'Error desconocido',
            ),
          ),
        ),
      );
      emit(AnalyticsError(error));
      return;
    }

    // All succeeded, emit combined state
    emit(AllAnalyticsLoaded(
      popularCourses: coursesResult.getOrElse(() => []),
      globalTrends: trendsResult.getOrElse(() => const GlobalTrends(
            periodoDias: 0,
            totalEventos: 0,
            usuariosActivos: 0,
            eventosPorTipo: {},
            eventosPorDia: {},
          )),
      instructorRankings: instructorsResult.getOrElse(() => []),
      userGrowth: growthResult.getOrElse(() => []),
    ));
  }
}
