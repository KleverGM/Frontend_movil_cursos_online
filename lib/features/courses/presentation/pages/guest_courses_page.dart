import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/course_filters.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_bottom_sheet.dart';

/// Página para explorar cursos sin autenticación (modo invitado)
class GuestCoursesPage extends StatelessWidget {
  const GuestCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>()..add(const GetCoursesEvent()),
      child: const _GuestCoursesContent(),
    );
  }
}

class _GuestCoursesContent extends StatefulWidget {
  const _GuestCoursesContent();

  @override
  State<_GuestCoursesContent> createState() => _GuestCoursesContentState();
}

class _GuestCoursesContentState extends State<_GuestCoursesContent> {
  final TextEditingController _searchController = TextEditingController();
  CourseFilters _currentFilters = const CourseFilters.empty();
  bool _showSearchBar = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applySearch(String query) {
    final newFilters = _currentFilters.copyWith(
      searchQuery: query.isEmpty ? null : query,
    );
    setState(() => _currentFilters = newFilters);
    context.read<CourseBloc>().add(GetCoursesEvent(filters: newFilters));
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onApplyFilters: (filters) {
          setState(() => _currentFilters = filters);
          context.read<CourseBloc>().add(GetCoursesEvent(filters: filters));
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = const CourseFilters.empty();
      _searchController.clear();
    });
    context.read<CourseBloc>().add(const GetCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.welcome),
        ),
        title: _showSearchBar
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar cursos...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: theme.appBarTheme.foregroundColor?.withOpacity( 0.7) ?? 
                           Colors.black54,
                  ),
                ),
                style: TextStyle(
                  color: theme.appBarTheme.foregroundColor ?? Colors.black,
                  fontSize: 16,
                ),
                onChanged: _applySearch,
              )
            : const Text('Explorar Cursos'),
        centerTitle: !_showSearchBar,
        actions: [
          if (!_showSearchBar)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _showSearchBar = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _showSearchBar = false;
                  _searchController.clear();
                });
                _applySearch('');
              },
            ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilters,
              ),
              if (_currentFilters.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner informativo para invitados
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity( 0.1),
              border: Border(
                bottom: BorderSide(color: theme.primaryColor.withOpacity( 0.2)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Navegas como invitado. Inicia sesión para inscribirte en cursos.',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.login),
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          // Mostrar filtros activos
          if (_currentFilters.hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.primaryColor.withOpacity( 0.1),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getActiveFiltersText(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
            ),
          
          // Lista de cursos
          Expanded(
            child: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, state) {
                if (state is CourseLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CoursesLoaded) {
                  if (state.courses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 80,
                            color: theme.colorScheme.primary.withOpacity( 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentFilters.hasActiveFilters
                                ? 'No se encontraron cursos'
                                : 'No hay cursos disponibles',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<CourseBloc>().add(GetCoursesEvent(filters: _currentFilters));
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.courses.length,
                      itemBuilder: (context, index) {
                        final course = state.courses[index];
                        return CourseCard(
                          course: course,
                          isGuestMode: true,
                        );
                      },
                    ),
                  );
                }

                if (state is CourseError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CourseBloc>().add(const GetCoursesEvent());
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getActiveFiltersText() {
    final List<String> parts = [];
    
    if (_currentFilters.searchQuery != null) {
      parts.add('Búsqueda: "${_currentFilters.searchQuery}"');
    }
    if (_currentFilters.categoria != null) {
      parts.add('Categoría: ${_currentFilters.categoria}');
    }
    if (_currentFilters.nivel != null) {
      parts.add('Nivel: ${_currentFilters.nivel}');
    }
    if (_currentFilters.precioMin != null || _currentFilters.precioMax != null) {
      parts.add('Precio: \$${_currentFilters.precioMin?.toStringAsFixed(0) ?? '0'} - \$${_currentFilters.precioMax?.toStringAsFixed(0) ?? '500'}');
    }
    
    return parts.join(' • ');
  }
}
