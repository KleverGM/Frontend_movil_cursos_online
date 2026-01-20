import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/change_password_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/update_profile.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/courses/data/datasources/course_remote_datasource.dart';
import '../../features/courses/data/datasources/module_remote_datasource.dart';
import '../../features/courses/data/datasources/section_remote_datasource.dart';
import '../../features/courses/data/repositories/course_repository_impl.dart';
import '../../features/courses/data/repositories/module_repository_impl.dart';
import '../../features/courses/data/repositories/section_repository_impl.dart';
import '../../features/courses/domain/repositories/course_repository.dart';
import '../../features/courses/domain/repositories/module_repository.dart';
import '../../features/courses/domain/repositories/section_repository.dart';
import '../../features/courses/domain/usecases/create_course_usecase.dart';
import '../../features/courses/domain/usecases/delete_course_usecase.dart';
import '../../features/courses/domain/usecases/enroll_in_course_usecase.dart';
import '../../features/courses/domain/usecases/get_course_detail_usecase.dart';
import '../../features/courses/domain/usecases/get_courses_usecase.dart';
import '../../features/courses/domain/usecases/get_enrolled_courses_usecase.dart';
import '../../features/courses/domain/usecases/get_instructor_enrollments_usecase.dart';
import '../../features/courses/domain/usecases/get_my_courses_usecase.dart';
import '../../features/courses/domain/usecases/mark_section_completed.dart';
import '../../features/courses/domain/usecases/update_course_usecase.dart';
import '../../features/courses/domain/usecases/get_course_stats_usecase.dart';
import '../../features/courses/domain/usecases/get_global_stats.dart';
import '../../features/courses/domain/usecases/toggle_course_status.dart';
import '../../features/courses/domain/usecases/get_modules_by_course.dart';
import '../../features/courses/domain/usecases/create_module.dart';
import '../../features/courses/domain/usecases/update_module.dart';
import '../../features/courses/domain/usecases/delete_module.dart';
import '../../features/courses/domain/usecases/get_sections_by_module.dart';
import '../../features/courses/domain/usecases/create_section.dart';
import '../../features/courses/domain/usecases/update_section.dart';
import '../../features/courses/domain/usecases/delete_section.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/courses/presentation/bloc/global_stats_bloc.dart';
import '../../features/courses/presentation/bloc/module_bloc.dart';
import '../../features/courses/presentation/bloc/section_bloc.dart';
import '../../features/reviews/data/datasources/review_remote_datasource.dart';
import '../../features/reviews/data/repositories/review_repository_impl.dart';
import '../../features/reviews/domain/repositories/review_repository.dart';
import '../../features/reviews/domain/usecases/create_review.dart';
import '../../features/reviews/domain/usecases/delete_review.dart';
import '../../features/reviews/domain/usecases/get_all_reviews.dart';
import '../../features/reviews/domain/usecases/get_course_review_stats.dart';
import '../../features/reviews/domain/usecases/get_course_reviews.dart';
import '../../features/reviews/domain/usecases/get_my_reviews.dart';
import '../../features/reviews/domain/usecases/mark_review_helpful.dart';
import '../../features/reviews/domain/usecases/reply_to_review.dart';
import '../../features/reviews/presentation/bloc/review_bloc.dart';
import '../../features/notices/data/datasources/notice_remote_datasource.dart';
import '../../features/notices/data/repositories/notice_repository_impl.dart';
import '../../features/notices/domain/repositories/notice_repository.dart';
import '../../features/notices/domain/usecases/create_notice.dart';
import '../../features/notices/domain/usecases/delete_notice.dart';
import '../../features/notices/domain/usecases/get_my_notices.dart';
import '../../features/notices/domain/usecases/mark_notice_as_read.dart';
import '../../features/notices/domain/usecases/get_all_notices.dart';
import '../../features/notices/domain/usecases/update_notice.dart';
import '../../features/notices/domain/usecases/create_broadcast_notice.dart';
import '../../features/notices/presentation/bloc/notice_bloc.dart';
import '../../features/enrollments/data/datasources/enrollment_remote_datasource.dart';
import '../../features/enrollments/data/datasources/enrollment_remote_datasource_impl.dart';
import '../../features/enrollments/data/repositories/enrollment_repository_impl.dart';
import '../../features/enrollments/domain/repositories/enrollment_repository.dart';
import '../../features/enrollments/domain/usecases/get_instructor_enrollments.dart';
import '../../features/enrollments/domain/usecases/get_enrollments_by_course.dart';
import '../../features/enrollments/presentation/bloc/enrollment_bloc.dart';
import '../../features/admin/data/datasources/admin_remote_datasource.dart';
import '../../features/admin/data/datasources/admin_remote_datasource_impl.dart';
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/activate_course.dart';
import '../../features/admin/domain/usecases/create_course_as_admin.dart';
import '../../features/admin/domain/usecases/create_enrollment_as_admin.dart';
import '../../features/admin/domain/usecases/create_user.dart';
import '../../features/admin/domain/usecases/deactivate_course.dart';
import '../../features/admin/domain/usecases/delete_course_as_admin.dart';
import '../../features/admin/domain/usecases/delete_enrollment_as_admin.dart';
import '../../features/admin/domain/usecases/delete_user.dart';
import '../../features/admin/domain/usecases/change_user_password.dart';
import '../../features/admin/domain/usecases/get_all_courses_admin.dart';
import '../../features/admin/domain/usecases/get_all_enrollments_admin.dart';
import '../../features/admin/domain/usecases/get_course_statistics.dart';
import '../../features/admin/domain/usecases/get_platform_stats.dart';
import '../../features/admin/domain/usecases/get_popular_courses.dart';
import '../../features/admin/domain/usecases/get_users.dart';
import '../../features/admin/domain/usecases/update_course_as_admin.dart';
import '../../features/admin/domain/usecases/update_enrollment_as_admin.dart';
import '../../features/admin/domain/usecases/update_user.dart';
import '../../features/admin/presentation/bloc/admin_bloc.dart';
import '../../features/analytics/data/datasources/analytics_remote_datasource.dart';
import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/domain/usecases/get_global_trends.dart';
import '../../features/analytics/domain/usecases/get_instructor_rankings.dart';
import '../../features/analytics/domain/usecases/get_popular_courses.dart';
import '../../features/analytics/domain/usecases/get_user_growth.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/datasources/settings_remote_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/change_password_usecase.dart' as settings;
import '../../features/settings/domain/usecases/get_preferences_usecase.dart';
import '../../features/settings/domain/usecases/save_preferences_usecase.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../network/api_client.dart';
import '../network/dio_interceptor.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

/// Inicializar todas las dependencias
Future<void> initializeDependencies() async {
  // ============== Core - External Dependencies ==============
  
  // SharedPreferences (singleton asíncrono)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // FlutterSecureStorage
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  // Connectivity
  getIt.registerSingleton<Connectivity>(Connectivity());

  // InternetConnectionChecker
  getIt.registerSingleton<InternetConnectionChecker>(
    InternetConnectionChecker(),
  );

  // ============== Core - Network ==============
  
  // Dio
  getIt.registerSingleton<Dio>(Dio());

  // AuthInterceptor
  getIt.registerSingleton<AuthInterceptor>(
    AuthInterceptor(
      dio: getIt<Dio>(),
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  // ApiClient
  getIt.registerSingleton<ApiClient>(
    ApiClient(
      dio: getIt<Dio>(),
      authInterceptor: getIt<AuthInterceptor>(),
    ),
  );

  // NetworkInfo
  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(
      connectivity: getIt<Connectivity>(),
      connectionChecker: getIt<InternetConnectionChecker>(),
    ),
  );

  // ============== Features - Auth ==============
  
  // DataSources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
    ),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => UpdateProfile(getIt<AuthRepository>()));

  // BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      updateProfile: getIt<UpdateProfile>(),
    ),
  );

  // ============== Features - Courses ==============
  
  // DataSources
  getIt.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      getIt<CourseRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetCoursesUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => GetCourseDetailUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => EnrollInCourseUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => GetEnrolledCoursesUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => GetMyCoursesUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => MarkSectionCompleted(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => CreateCourseUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => UpdateCourseUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => DeleteCourseUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => GetInstructorEnrollmentsUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => GetCourseStatsUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => ActivateCourseUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => DeactivateCourseUseCase(getIt<CourseRepository>()));
  getIt.registerLazySingleton(() => GetGlobalStatsUseCase(getIt<CourseRepository>()));

  // BLoC
  getIt.registerFactory(
    () => CourseBloc(
      getIt<GetCoursesUseCase>(),
      getIt<GetCourseDetailUseCase>(),
      getIt<EnrollInCourseUseCase>(),
      getIt<GetEnrolledCoursesUseCase>(),
      getIt<GetMyCoursesUseCase>(),
      getIt<MarkSectionCompleted>(),
      getIt<CreateCourseUseCase>(),
      getIt<UpdateCourseUseCase>(),
      getIt<DeleteCourseUseCase>(),
      getIt<GetInstructorEnrollmentsUseCase>(),
      getIt<ActivateCourseUseCase>(),
      getIt<DeactivateCourseUseCase>(),
      getIt<GetCourseStatsUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GlobalStatsBloc(getIt<CourseRepository>()),
  );

  // ============== Features - Modules ==============
  
  // DataSources
  getIt.registerLazySingleton<ModuleRemoteDataSource>(
    () => ModuleRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<ModuleRepository>(
    () => ModuleRepositoryImpl(
      getIt<ModuleRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetModulesByCourseUseCase(getIt<ModuleRepository>()));
  getIt.registerLazySingleton(() => CreateModuleUseCase(getIt<ModuleRepository>()));
  getIt.registerLazySingleton(() => UpdateModuleUseCase(getIt<ModuleRepository>()));
  getIt.registerLazySingleton(() => DeleteModuleUseCase(getIt<ModuleRepository>()));

  // BLoC
  getIt.registerFactory(
    () => ModuleBloc(
      getIt<GetModulesByCourseUseCase>(),
      getIt<CreateModuleUseCase>(),
      getIt<UpdateModuleUseCase>(),
      getIt<DeleteModuleUseCase>(),
    ),
  );

  // ============== Features - Sections ==============
  
  // DataSources
  getIt.registerLazySingleton<SectionRemoteDataSource>(
    () => SectionRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<SectionRepository>(
    () => SectionRepositoryImpl(
      getIt<SectionRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetSectionsByModuleUseCase(getIt<SectionRepository>()));
  getIt.registerLazySingleton(() => CreateSectionUseCase(getIt<SectionRepository>()));
  getIt.registerLazySingleton(() => UpdateSectionUseCase(getIt<SectionRepository>()));
  getIt.registerLazySingleton(() => DeleteSectionUseCase(getIt<SectionRepository>()));

  // BLoC
  getIt.registerFactory(
    () => SectionBloc(
      getIt<GetSectionsByModuleUseCase>(),
      getIt<CreateSectionUseCase>(),
      getIt<UpdateSectionUseCase>(),
      getIt<DeleteSectionUseCase>(),
      getIt<MarkSectionCompleted>(),
    ),
  );

  // ============== Features - Reviews ==============
  
  // DataSources
  getIt.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(
      getIt<ApiClient>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(
      getIt<ReviewRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetCourseReviews(getIt<ReviewRepository>()));
  getIt.registerLazySingleton(() => GetCourseReviewStats(getIt<ReviewRepository>()));
  getIt.registerLazySingleton(() => GetMyReviews(getIt<ReviewRepository>()));
  getIt.registerLazySingleton(() => CreateReview(getIt<ReviewRepository>()));
  getIt.registerLazySingleton(() => MarkReviewHelpful(getIt<ReviewRepository>()));
  getIt.registerLazySingleton(() => DeleteReview(getIt<ReviewRepository>()));
  getIt.registerLazySingleton(() => ReplyToReview(getIt<ReviewRepository>()));
  getIt.registerLazySingleton(() => GetAllReviewsUseCase(getIt<ReviewRepository>()));

  // BLoC
  getIt.registerFactory(
    () => ReviewBloc(
      getIt<GetCourseReviews>(),
      getIt<GetCourseReviewStats>(),
      getIt<GetMyReviews>(),
      getIt<CreateReview>(),
      getIt<MarkReviewHelpful>(),
      getIt<DeleteReview>(),
      getIt<ReplyToReview>(),
      getIt<GetAllReviewsUseCase>(),
    ),
  );

  // ============== Features - Notices ==============
  
  // DataSources
  getIt.registerLazySingleton<NoticeRemoteDataSource>(
    () => NoticeRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<NoticeRepository>(
    () => NoticeRepositoryImpl(
      getIt<NoticeRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetMyNoticesUseCase(getIt<NoticeRepository>()));
  getIt.registerLazySingleton(() => MarkNoticeAsReadUseCase(getIt<NoticeRepository>()));
  getIt.registerLazySingleton(() => DeleteNoticeUseCase(getIt<NoticeRepository>()));
  getIt.registerLazySingleton(() => CreateNoticeUseCase(getIt<NoticeRepository>()));
  getIt.registerLazySingleton(() => GetAllNoticesUseCase(getIt<NoticeRepository>()));
  getIt.registerLazySingleton(() => UpdateNoticeUseCase(getIt<NoticeRepository>()));
  getIt.registerLazySingleton(() => CreateBroadcastNoticeUseCase(getIt<NoticeRepository>()));

  // BLoC
  getIt.registerFactory(
    () => NoticeBloc(
      getIt<GetMyNoticesUseCase>(),
      getIt<MarkNoticeAsReadUseCase>(),
      getIt<DeleteNoticeUseCase>(),
      getIt<CreateNoticeUseCase>(),
      getIt<GetAllNoticesUseCase>(),
      getIt<UpdateNoticeUseCase>(),
      getIt<CreateBroadcastNoticeUseCase>(),
    ),
  );

  // ============== Features - Enrollments ==============
  
  // DataSources
  getIt.registerLazySingleton<EnrollmentRemoteDataSource>(
    () => EnrollmentRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<EnrollmentRepository>(
    () => EnrollmentRepositoryImpl(
      remoteDataSource: getIt<EnrollmentRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetInstructorEnrollments(getIt<EnrollmentRepository>()));
  getIt.registerLazySingleton(() => GetEnrollmentsByCourse(getIt<EnrollmentRepository>()));

  // BLoC
  getIt.registerFactory(
    () => EnrollmentBloc(
      getInstructorEnrollments: getIt<GetInstructorEnrollments>(),
      getEnrollmentsByCourse: getIt<GetEnrollmentsByCourse>(),
    ),
  );

  // ============== Features - Admin ==============
  
  // DataSources
  getIt.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(
      remoteDataSource: getIt<AdminRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetPlatformStats(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => GetPopularCourses(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => GetUsers(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => CreateUser(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => UpdateUser(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => DeleteUser(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => ChangeUserPassword(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => GetAllCoursesAdmin(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => CreateCourseAsAdmin(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => UpdateCourseAsAdmin(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => DeleteCourseAsAdmin(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => ActivateCourse(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => DeactivateCourse(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => GetCourseStatistics(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => GetAllEnrollmentsAdmin(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => CreateEnrollmentAsAdmin(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => UpdateEnrollmentAsAdmin(getIt<AdminRepository>()));
  getIt.registerLazySingleton(() => DeleteEnrollmentAsAdmin(getIt<AdminRepository>()));

  // BLoC
  getIt.registerFactory(
    () => AdminBloc(
      getPlatformStats: getIt<GetPlatformStats>(),
      getPopularCourses: getIt<GetPopularCourses>(),
      getUsers: getIt<GetUsers>(),
      createUser: getIt<CreateUser>(),
      updateUser: getIt<UpdateUser>(),
      deleteUser: getIt<DeleteUser>(),
      changeUserPassword: getIt<ChangeUserPassword>(),
      getAllCoursesAdmin: getIt<GetAllCoursesAdmin>(),
      createCourseAsAdmin: getIt<CreateCourseAsAdmin>(),
      updateCourseAsAdmin: getIt<UpdateCourseAsAdmin>(),
      deleteCourseAsAdmin: getIt<DeleteCourseAsAdmin>(),
      activateCourse: getIt<ActivateCourse>(),
      deactivateCourse: getIt<DeactivateCourse>(),
      getCourseStatistics: getIt<GetCourseStatistics>(),
      getAllEnrollmentsAdmin: getIt<GetAllEnrollmentsAdmin>(),
      createEnrollmentAsAdmin: getIt<CreateEnrollmentAsAdmin>(),
      updateEnrollmentAsAdmin: getIt<UpdateEnrollmentAsAdmin>(),
      deleteEnrollmentAsAdmin: getIt<DeleteEnrollmentAsAdmin>(),
    ),
  );

  // ============== Features - Analytics ==============
  
  // DataSources
  getIt.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSourceImpl(
      getIt<ApiClient>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      getIt<AnalyticsRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetPopularCoursesUseCase(getIt<AnalyticsRepository>()));
  getIt.registerLazySingleton(() => GetGlobalTrendsUseCase(getIt<AnalyticsRepository>()));
  getIt.registerLazySingleton(() => GetInstructorRankingsUseCase(getIt<AnalyticsRepository>()));
  getIt.registerLazySingleton(() => GetUserGrowthUseCase(getIt<AnalyticsRepository>()));

  // BLoC
  getIt.registerFactory(
    () => AnalyticsBloc(
      getIt<GetPopularCoursesUseCase>(),
      getIt<GetGlobalTrendsUseCase>(),
      getIt<GetInstructorRankingsUseCase>(),
      getIt<GetUserGrowthUseCase>(),
    ),
  );

  // ============== Features - Settings ==============
  
  // DataSources
  getIt.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Repository
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: getIt<SettingsRemoteDataSource>(),
      localDataSource: getIt<SettingsLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => settings.ChangePasswordUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetPreferencesUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerLazySingleton(
    () => SavePreferencesUseCase(getIt<SettingsRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => SettingsBloc(
      getPreferencesUseCase: getIt<GetPreferencesUseCase>(),
      savePreferencesUseCase: getIt<SavePreferencesUseCase>(),
      changePasswordUseCase: getIt<settings.ChangePasswordUseCase>(),
    ),
  );
}
