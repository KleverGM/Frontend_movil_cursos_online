import 'package:flutter/material.dart';

/// Widget para filtros de reseñas del instructor
class InstructorReviewsFilters extends StatelessWidget {
  final String searchQuery;
  final int? selectedRating;
  final String selectedResponseFilter;
  final Function(String) onSearchChanged;
  final Function(int?) onRatingChanged;
  final Function(String) onResponseFilterChanged;
  final VoidCallback onClearFilters;

  const InstructorReviewsFilters({
    super.key,
    required this.searchQuery,
    required this.selectedRating,
    required this.selectedResponseFilter,
    required this.onSearchChanged,
    required this.onRatingChanged,
    required this.onResponseFilterChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda
        TextField(
          onChanged: onSearchChanged,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Buscar por comentario, estudiante o curso...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
        ),
        
        const SizedBox(height: 16),

        // Filtros en chips
        Row(
          children: [
            Text(
              'Filtrar por:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Filtros de calificación
                    for (int rating = 1; rating <= 5; rating++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              Text(' $rating'),
                            ],
                          ),
                          selected: selectedRating == rating,
                          onSelected: (selected) {
                            onRatingChanged(selected ? rating : null);
                          },
                        ),
                      ),
                    
                    // Filtro por respuesta
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Pendientes'),
                        selected: selectedResponseFilter == 'pending',
                        onSelected: (selected) {
                          onResponseFilterChanged(selected ? 'pending' : 'all');
                        },
                      ),
                    ),
                    
                    FilterChip(
                      label: const Text('Respondidas'),
                      selected: selectedResponseFilter == 'answered',
                      onSelected: (selected) {
                        onResponseFilterChanged(selected ? 'answered' : 'all');
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Botón para limpiar filtros
            if (selectedRating != null || 
                selectedResponseFilter != 'all' || 
                searchQuery.isNotEmpty)
              IconButton(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear),
                tooltip: 'Limpiar filtros',
              ),
          ],
        ),
      ],
    );
  }
}
