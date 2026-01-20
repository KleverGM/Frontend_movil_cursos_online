import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/global_stats_bloc.dart';
import '../bloc/global_stats_event.dart';
import '../bloc/global_stats_state.dart';
import '../widgets/global_stats_widgets.dart';

/// Página de estadísticas globales de la plataforma (solo para administradores)
class GlobalStatsPage extends StatefulWidget {
  final GlobalStatsBloc bloc;
  
  const GlobalStatsPage({super.key, required this.bloc});

  @override
  State<GlobalStatsPage> createState() => _GlobalStatsPageState();
}

class _GlobalStatsPageState extends State<GlobalStatsPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(const LoadGlobalStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas Globales'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              widget.bloc.add(const RefreshGlobalStatsEvent());
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocBuilder<GlobalStatsBloc, GlobalStatsState>(
        bloc: widget.bloc,
        builder: (context, state) {
          if (state is GlobalStatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GlobalStatsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar estadísticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.bloc.add(const LoadGlobalStatsEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is GlobalStatsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                widget.bloc.add(const RefreshGlobalStatsEvent());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tarjetas de estadísticas principales
                    GlobalStatsCardsGrid(stats: state.stats),
                    const SizedBox(height: 24),

                    // Distribución de cursos por categoría
                    if (state.stats.cursosPorCategoria.isNotEmpty) ...[
                      const SectionTitle('Cursos por Categoría'),
                      const SizedBox(height: 12),
                      CategoryDistributionChart(
                        categorias: state.stats.cursosPorCategoria,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Top instructores
                    if (state.stats.topInstructores.isNotEmpty) ...[
                      const SectionTitle('Top Instructores'),
                      const SizedBox(height: 12),
                      TopInstructorsList(
                        instructores: state.stats.topInstructores,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text('Carga las estadísticas de la plataforma'),
          );
        },
      ),
    );
  }
}
