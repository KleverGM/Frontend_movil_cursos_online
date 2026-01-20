part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final PlatformStats? platformStats;
  final List<PopularCourse> popularCourses;
  final List<UserSummary> users;
  final List<Course> courses;
  final CourseStatsAdmin? courseStats;
  final List<EnrollmentAdmin> enrollments;

  const AdminLoaded({
    this.platformStats,
    this.popularCourses = const [],
    this.users = const [],
    this.courses = const [],
    this.courseStats,
    this.enrollments = const [],
  });

  AdminLoaded copyWith({
    PlatformStats? platformStats,
    List<PopularCourse>? popularCourses,
    List<UserSummary>? users,
    List<Course>? courses,
    CourseStatsAdmin? courseStats,
    List<EnrollmentAdmin>? enrollments,
  }) {
    return AdminLoaded(
      platformStats: platformStats ?? this.platformStats,
      popularCourses: popularCourses ?? this.popularCourses,
      users: users ?? this.users,
      courses: courses ?? this.courses,
      courseStats: courseStats ?? this.courseStats,
      enrollments: enrollments ?? this.enrollments,
    );
  }

  @override
  List<Object?> get props => [platformStats, popularCourses, users, courses, courseStats, enrollments];
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
