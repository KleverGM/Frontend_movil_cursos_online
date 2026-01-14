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
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/courses/data/datasources/course_remote_datasource.dart';
import '../../features/courses/data/repositories/course_repository_impl.dart';
import '../../features/courses/domain/repositories/course_repository.dart';
import '../../features/courses/domain/usecases/enroll_in_course_usecase.dart';
import '../../features/courses/domain/usecases/get_course_detail_usecase.dart';
import '../../features/courses/domain/usecases/get_courses_usecase.dart';
import '../../features/courses/domain/usecases/get_enrolled_courses_usecase.dart';
import '../../features/courses/domain/usecases/get_my_courses_usecase.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
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

  // BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
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

  // BLoC
  getIt.registerFactory(
    () => CourseBloc(
      getIt<GetCoursesUseCase>(),
      getIt<GetCourseDetailUseCase>(),
      getIt<EnrollInCourseUseCase>(),
      getIt<GetEnrolledCoursesUseCase>(),
      getIt<GetMyCoursesUseCase>(),
    ),
  );
}
