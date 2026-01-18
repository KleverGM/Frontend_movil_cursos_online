import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'instructor_main_layout.dart';
import 'main_layout.dart';

/// Wrapper que selecciona el layout correcto basado en el perfil del usuario
class AdaptiveMainLayout extends StatelessWidget {
  const AdaptiveMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Si es instructor o admin, mostrar layout de instructor
          if (state.user.isInstructor || state.user.isAdmin) {
            return const InstructorMainLayout();
          }
          // Si es estudiante, mostrar layout normal
          return const MainLayout();
        }

        // Estado por defecto (no debería llegar aquí si el routing está bien configurado)
        return const MainLayout();
      },
    );
  }
}
