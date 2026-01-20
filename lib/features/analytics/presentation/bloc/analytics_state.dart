import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics_entities.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class PopularCoursesLoaded extends AnalyticsState {
  final List<CourseAnalytics> courses;

  const PopularCoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class GlobalTrendsLoaded extends AnalyticsState {
  final GlobalTrends trends;

  const GlobalTrendsLoaded(this.trends);

  @override
  List<Object?> get props => [trends];
}

class InstructorRankingsLoaded extends AnalyticsState {
  final List<InstructorAnalytics> instructors;

  const InstructorRankingsLoaded(this.instructors);

  @override
  List<Object?> get props => [instructors];
}

class UserGrowthLoaded extends AnalyticsState {
  final List<UserGrowth> growth;

  const UserGrowthLoaded(this.growth);

  @override
  List<Object?> get props => [growth];
}

class CourseStatsLoaded extends AnalyticsState {
  final CourseStats stats;

  const CourseStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class AllAnalyticsLoaded extends AnalyticsState {
  final List<CourseAnalytics> popularCourses;
  final GlobalTrends globalTrends;
  final List<InstructorAnalytics> instructorRankings;
  final List<UserGrowth> userGrowth;

  const AllAnalyticsLoaded({
    required this.popularCourses,
    required this.globalTrends,
    required this.instructorRankings,
    required this.userGrowth,
  });

  @override
  List<Object?> get props => [
        popularCourses,
        globalTrends,
        instructorRankings,
        userGrowth,
      ];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
