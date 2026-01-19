import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/review.dart';
import 'rating_display.dart';

/// Card de reseña personalizada para instructores que incluye información del curso
class InstructorReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onReply;

  const InstructorReviewCard({
    super.key,
    required this.review,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información del curso y estudiante
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    review.estudianteNombre[0].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del estudiante y calificación
                      Row(
                        children: [
                          Text(
                            review.estudianteNombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          RatingDisplay(
                            rating: review.calificacion.toDouble(),
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Título del curso
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Text(
                          review.cursoTitulo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Fecha
                      Text(
                        DateFormat('dd/MM/yyyy').format(review.fechaCreacion),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
              style: const TextStyle(fontSize: 14),
            ),
            
            // Respuesta del instructor
            if (review.respuestaInstructorActual != null && review.respuestaInstructorActual!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.reply,
                          size: 16,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tu respuesta:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.respuestaInstructorActual!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (review.fechaRespuesta != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy').format(review.fechaRespuesta!),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            
            // Botones de acción
            const SizedBox(height: 12),
            Row(
              children: [
                // Indicador de respuesta pendiente
                if (review.respuestaInstructorActual == null || review.respuestaInstructorActual!.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[300]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Pendiente respuesta',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const Spacer(),
                
                // Botón de responder/editar respuesta
                if (onReply != null)
                  TextButton.icon(
                    onPressed: onReply,
                    icon: Icon(
                      review.respuestaInstructorActual != null && review.respuestaInstructorActual!.isNotEmpty
                          ? Icons.edit
                          : Icons.reply,
                      size: 16,
                    ),
                    label: Text(
                      review.respuestaInstructorActual != null && review.respuestaInstructorActual!.isNotEmpty
                          ? 'Editar respuesta'
                          : 'Responder',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}