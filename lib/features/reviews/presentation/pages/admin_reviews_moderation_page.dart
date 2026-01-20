import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/cards/stat_card.dart';
import '../../../../core/widgets/filters/filter_widgets.dart';
import '../../domain/entities/review.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';

class AdminReviewsModerationPage extends StatefulWidget {
  const AdminReviewsModerationPage({Key? key}) : super(key: key);

  @override
  State<AdminReviewsModerationPage> createState() => _AdminReviewsModerationPageState();
}

class _AdminReviewsModerationPageState extends State<AdminReviewsModerationPage> {
  String _searchQuery = '';
  double? _ratingFilter;
  
  List<Review> _allReviews = [];
  bool _isDeleting = false;
  
  List<Review> get _filteredReviews {
    var filtered = _allReviews;
    
    // Filtro de búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((review) {
        return review.comentario.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               review.estudianteNombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               review.cursoTitulo.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Filtro de calificación
    if (_ratingFilter != null) {
      filtered = filtered.where((review) => review.calificacion == _ratingFilter).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReviewBloc>()..add(const GetAllReviewsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Moderación de Reseñas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<ReviewBloc>().add(const GetAllReviewsEvent());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Barra de búsqueda y filtros
            _buildFiltersSection(),
            
            // Lista de reseñas
            Expanded(
              child: BlocConsumer<ReviewBloc, ReviewState>(
                listener: (context, state) {
                  if (state is ReviewDeleted && !_isDeleting) {
                    _isDeleting = true;
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reseña eliminada exitosamente'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    
                    // Recargar lista después de un pequeño delay
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.read<ReviewBloc>().add(const GetAllReviewsEvent());
                        _isDeleting = false;
                      }
                    });
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is AllReviewsLoaded) {
                    _allReviews = state.reviews;
                    
                    if (_filteredReviews.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rate_review_outlined,
                                size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron reseñas',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return Column(
                      children: [
                        // Estadísticas
                        _buildStatsSection(_allReviews),
                        
                        // Lista
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredReviews.length,
                            itemBuilder: (context, index) {
                              return _buildReviewCard(_filteredReviews[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  
                  return const Center(child: Text('Sin datos'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity( 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Buscador
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por comentario, usuario o curso...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 12),
          
          // Filtros de calificación
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(
                  label: 'Todas',
                  isSelected: _ratingFilter == null,
                  onTap: () {
                    setState(() => _ratingFilter = null);
                  },
                ),
                const SizedBox(width: 8),
                for (int i = 5; i >= 1; i--)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChipWidget(
                      label: '$i ⭐',
                      isSelected: _ratingFilter == i.toDouble(),
                      onTap: () {
                        setState(() => _ratingFilter = i.toDouble());
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(List<Review> reviews) {
    if (reviews.isEmpty) return const SizedBox.shrink();
    
    final totalReviews = reviews.length;
    final averageRating = reviews.fold<double>(
      0, (sum, review) => sum + review.calificacion.toDouble()) / totalReviews;
    
    final ratingDistribution = <int, int>{};
    for (var i = 1; i <= 5; i++) {
      ratingDistribution[i] = reviews.where((r) => r.calificacion == i).length;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatCard(
                title: 'Total',
                value: totalReviews.toString(),
                icon: Icons.rate_review,
                color: Colors.blue,
                compact: true,
              ),
              StatCard(
                title: 'Promedio',
                value: averageRating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.orange,
                compact: true,
              ),
              StatCard(
                title: '5 ⭐',
                value: ratingDistribution[5].toString(),
                icon: Icons.thumb_up,
                color: Colors.green,
                compact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con usuario y curso
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    review.estudianteNombre.isNotEmpty 
                        ? review.estudianteNombre[0].toUpperCase() 
                        : 'U',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.estudianteNombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        review.cursoTitulo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getRatingColor(review.calificacion.toDouble()).withOpacity( 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 18,
                        color: _getRatingColor(review.calificacion.toDouble()),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        review.calificacion.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getRatingColor(review.calificacion.toDouble()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Comentario
            Text(
              review.comentario,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 12),
            
            // Footer con fecha y acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(review.fechaCreacion),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    // Nota: verificadoCompra no existe en esta entidad
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(review),
                  tooltip: 'Eliminar reseña',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.lightGreen;
    if (rating >= 2.5) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      return 'Hace ${(difference.inDays / 7).floor()} semanas';
    } else if (difference.inDays < 365) {
      return 'Hace ${(difference.inDays / 30).floor()} meses';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _confirmDelete(Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Reseña'),
        content: Text(
          '¿Estás seguro de que deseas eliminar esta reseña de ${review.estudianteNombre}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ReviewBloc>().add(DeleteReviewEvent(review.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
