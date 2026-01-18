import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../widgets/rating_input.dart';

/// Diálogo para crear o editar una reseña
class CreateReviewDialog extends StatefulWidget {
  final int cursoId;
  final String cursoTitulo;
  final ReviewBloc reviewBloc;

  const CreateReviewDialog({
    super.key,
    required this.cursoId,
    required this.cursoTitulo,
    required this.reviewBloc,
  });

  @override
  State<CreateReviewDialog> createState() => _CreateReviewDialogState();
}

class _CreateReviewDialogState extends State<CreateReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _comentarioController = TextEditingController();
  int _calificacion = 0;

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Escribe una reseña',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.cursoTitulo,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                // Calificación
                const Text(
                  'Calificación',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: RatingInput(
                    onRatingChanged: (rating) {
                      setState(() {
                        _calificacion = rating;
                      });
                    },
                  ),
                ),
                if (_calificacion == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Selecciona una calificación',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Comentario
                const Text(
                  'Comentario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _comentarioController,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: 'Comparte tu experiencia con este curso...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor escribe un comentario';
                    }
                    if (value.trim().length < 10) {
                      return 'El comentario debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: const Text('Publicar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitReview() {
    if (_calificacion == 0) {
      setState(() {}); // Para mostrar el mensaje de error
      return;
    }

    if (_formKey.currentState!.validate()) {
      widget.reviewBloc.add(
        CreateReviewEvent(
          cursoId: widget.cursoId,
          calificacion: _calificacion,
          comentario: _comentarioController.text.trim(),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
