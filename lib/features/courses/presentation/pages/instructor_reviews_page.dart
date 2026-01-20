import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../reviews/presentation/bloc/review_bloc.dart';
import '../../../reviews/presentation/bloc/review_event.dart';
import '../../../reviews/presentation/bloc/review_state.dart';
import '../../../reviews/presentation/widgets/instructor_reviews_stats.dart';
import '../../../reviews/presentation/widgets/instructor_reviews_filters.dart';
import '../../../reviews/presentation/widgets/instructor_reviews_list.dart';
import '../../../reviews/domain/entities/review.dart';

/// Dashboard para que instructores gestionen todas las reseñas de sus cursos
class InstructorReviewsPage extends StatefulWidget {
  const InstructorReviewsPage({super.key});

  @override
  State<InstructorReviewsPage> createState() => _InstructorReviewsPageState();
}

class _InstructorReviewsPageState extends State<InstructorReviewsPage> {
  String _searchQuery = '';
  int? _selectedRating;
  String _selectedResponseFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadMyReviews();
  }

  void _loadMyReviews() {
    context.read<ReviewBloc>().add(const GetMyReviewsEvent());
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedRating = null;
      _selectedResponseFilter = 'all';
    });
  }

  List<Review> _filterReviews(List<Review> reviews) {
    List<Review> filtered = List.from(reviews);

    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((review) {
        return review.comentario.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               review.estudianteNombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               review.cursoTitulo.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filtrar por calificación
    if (_selectedRating != null) {
      filtered = filtered.where((review) => review.calificacion == _selectedRating).toList();
    }

    // Filtrar por respuesta
    switch (_selectedResponseFilter) {
      case 'pending':
        filtered = filtered
            .where((r) => r.respuestaInstructorActual == null || r.respuestaInstructorActual!.isEmpty)
            .toList();
        break;
      case 'answered':
        filtered = filtered
            .where((r) => r.respuestaInstructorActual != null && r.respuestaInstructorActual!.isNotEmpty)
            .toList();
        break;
    }

    // Ordenar: sin respuesta primero, luego por fecha
    filtered.sort((a, b) {
      final aHasResponse = a.respuestaInstructorActual != null && a.respuestaInstructorActual!.isNotEmpty;
      final bHasResponse = b.respuestaInstructorActual != null && b.respuestaInstructorActual!.isNotEmpty;
      
      if (aHasResponse != bHasResponse) {
        return aHasResponse ? 1 : -1; // Sin respuesta primero
      }
      
      return b.fechaCreacion.compareTo(a.fechaCreacion); // Más recientes primero
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Reseñas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMyReviews,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewReplied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Respuesta enviada exitosamente!'),
                backgroundColor: Colors.green,
              ),
            );
            _loadMyReviews();
          } else if (state is ReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReviewError) {
            return _buildError(state.message);
          }

          if (state is ReviewsLoaded || state is MyReviewsLoaded) {
            final reviews = state is MyReviewsLoaded 
                ? state.reviews 
                : (state as ReviewsLoaded).reviews;
            final filteredReviews = _filterReviews(reviews);

            return Column(
              children: [
                // Estadísticas
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: InstructorReviewsStats(reviews: reviews),
                ),

                // Filtros
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InstructorReviewsFilters(
                    searchQuery: _searchQuery,
                    selectedRating: _selectedRating,
                    selectedResponseFilter: _selectedResponseFilter,
                    onSearchChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    onRatingChanged: (rating) {
                      setState(() {
                        _selectedRating = rating;
                      });
                    },
                    onResponseFilterChanged: (filter) {
                      setState(() {
                        _selectedResponseFilter = filter;
                      });
                    },
                    onClearFilters: _clearFilters,
                  ),
                ),

                const SizedBox(height: 16),

                // Lista de reseñas
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _loadMyReviews();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InstructorReviewsList(
                        reviews: filteredReviews,
                        onRefresh: _loadMyReviews,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Estado inicial
          return const Center(
            child: Text('Cargando reseñas...'),
          );
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar reseñas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadMyReviews,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
