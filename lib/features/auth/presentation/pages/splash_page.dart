import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// Página de Splash que verifica el estado de autenticación
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Esperar un momento para que el AuthBloc termine de verificar
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Pequeña espera para mostrar el splash
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final authState = context.read<AuthBloc>().state;

    // Verificar estado actual primero
    if (authState is Authenticated) {
      // Usuario autenticado - ir al home
      context.go(AppRoutes.home);
    } else if (authState is Unauthenticated) {
      // Ya sabemos que no está autenticado - ir a welcome
      context.go(AppRoutes.welcome);
    } else {
      // Estado inicial o cargando - esperar a que termine la verificación
      // El BlocListener se encargará de la navegación
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(AppRoutes.home);
        } else if (state is Unauthenticated) {
          context.go(AppRoutes.welcome);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.school,
                  size: 64,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Cursos Online',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
