import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class GetPopularCoursesEvent extends AnalyticsEvent {
  final int days;

  const GetPopularCoursesEvent({this.days = 30});

  @override
  List<Object?> get props => [days];
}

class GetGlobalTrendsEvent extends AnalyticsEvent {
  final int days;

  const GetGlobalTrendsEvent({this.days = 30});

  @override
  List<Object?> get props => [days];
}

class GetInstructorRankingsEvent extends AnalyticsEvent {
  const GetInstructorRankingsEvent();
}

class GetUserGrowthEvent extends AnalyticsEvent {
  final int days;

  const GetUserGrowthEvent({this.days = 30});

  @override
  List<Object?> get props => [days];
}

class GetCourseStatsEvent extends AnalyticsEvent {
  final int cursoId;
  final int days;

  const GetCourseStatsEvent({
    required this.cursoId,
    this.days = 30,
  });

  @override
  List<Object?> get props => [cursoId, days];
}

class RefreshAllAnalyticsEvent extends AnalyticsEvent {
  final int days;

  const RefreshAllAnalyticsEvent({this.days = 30});

  @override
  List<Object?> get props => [days];
}
