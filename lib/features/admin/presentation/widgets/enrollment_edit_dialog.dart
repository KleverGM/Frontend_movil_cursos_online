import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/enrollment_admin.dart';
import '../bloc/admin_bloc.dart';

class EnrollmentEditDialog extends StatefulWidget {
  final EnrollmentAdmin enrollment;

  const EnrollmentEditDialog({
    super.key,
    required this.enrollment,
  });

  @override
  State<EnrollmentEditDialog> createState() => _EnrollmentEditDialogState();
}

class _EnrollmentEditDialogState extends State<EnrollmentEditDialog> {
  late double _progreso;
  late bool _completado;

  @override
  void initState() {
    super.initState();
    _progreso = widget.enrollment.progreso;
    _completado = widget.enrollment.completado;
  }

  void _submit() {
    context.read<AdminBloc>().add(
      UpdateEnrollmentAsAdminEvent(
        enrollmentId: widget.enrollment.id,
        progreso: _progreso,
        completado: _completado,
      ),
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inscripción actualizada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetProgress() {
    setState(() {
      _progreso = 0.0;
      _completado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Inscripción'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del curso y estudiante
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity( 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity( 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.enrollment.cursoTitulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.enrollment.usuarioNombre,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.enrollment.usuarioEmail,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Control de progreso
            const Text(
              'Progreso del Curso',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _progreso,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_progreso.toStringAsFixed(0)}%',
                    onChanged: (value) {
                      setState(() {
                        _progreso = value;
                        // Auto-marcar como completado si llega a 100%
                        if (value >= 100) {
                          _completado = true;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity( 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_progreso.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Toggle de completado
            SwitchListTile(
              title: const Text('Curso Completado'),
              subtitle: Text(
                _completado
                    ? 'El estudiante ha completado el curso'
                    : 'El curso aún no está completado',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              value: _completado,
              onChanged: (value) {
                setState(() {
                  _completado = value;
                  // Si se marca como completado, poner progreso en 100%
                  if (value && _progreso < 100) {
                    _progreso = 100;
                  }
                });
              },
              activeThumbColor: Colors.green,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),

            // Botón de resetear
            OutlinedButton.icon(
              onPressed: _resetProgress,
              icon: const Icon(Icons.refresh),
              label: const Text('Resetear Progreso a 0%'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 16),

            // Nota informativa
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity( 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity( 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Los cambios afectarán el progreso real del estudiante en el curso.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Guardar Cambios'),
        ),
      ],
    );
  }
}
