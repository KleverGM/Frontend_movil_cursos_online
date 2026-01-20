import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/theme_config.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/courses/presentation/bloc/course_bloc.dart';
import 'features/courses/presentation/bloc/module_bloc.dart';
import 'features/courses/presentation/bloc/section_bloc.dart';
import 'features/reviews/presentation/bloc/review_bloc.dart';
import 'features/admin/presentation/bloc/admin_bloc.dart';
import 'features/enrollments/presentation/bloc/enrollment_bloc.dart';
import 'features/notices/presentation/bloc/notice_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar dependencias
  await initializeDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthenticationStatus()),
        ),
        BlocProvider(
          create: (_) => getIt<CourseBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<ModuleBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<SectionBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<ReviewBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<AdminBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<EnrollmentBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<NoticeBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos Online'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido!',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Nivel 1 - Configuración Básica',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            const Text('✅ Constantes configuradas'),
            const Text('✅ Tema claro/oscuro listo'),
            const Text('✅ Validadores y utilidades'),
            const Text('✅ Widgets reutilizables'),
            const Text('✅ Sistema de errores'),
          ],
        ),
      ),
    );
  }
}

