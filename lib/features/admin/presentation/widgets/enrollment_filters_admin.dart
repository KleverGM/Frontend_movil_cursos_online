import 'package:flutter/material.dart';

class EnrollmentFiltersAdmin extends StatefulWidget {
  final int? selectedCursoId;
  final int? selectedUsuarioId;
  final bool? selectedCompletado;
  final Function({int? cursoId, int? usuarioId, bool? completado}) onApplyFilters;
  final VoidCallback onClearFilters;

  const EnrollmentFiltersAdmin({
    super.key,
    this.selectedCursoId,
    this.selectedUsuarioId,
    this.selectedCompletado,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<EnrollmentFiltersAdmin> createState() => _EnrollmentFiltersAdminState();
}

class _EnrollmentFiltersAdminState extends State<EnrollmentFiltersAdmin> {
  int? _cursoId;
  int? _usuarioId;
  bool? _completado;

  final TextEditingController _cursoIdController = TextEditingController();
  final TextEditingController _usuarioIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cursoId = widget.selectedCursoId;
    _usuarioId = widget.selectedUsuarioId;
    _completado = widget.selectedCompletado;

    if (_cursoId != null) {
      _cursoIdController.text = _cursoId.toString();
    }
    if (_usuarioId != null) {
      _usuarioIdController.text = _usuarioId.toString();
    }
  }

  @override
  void dispose() {
    _cursoIdController.dispose();
    _usuarioIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtrar Inscripciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Filtro por ID de curso
              TextField(
                controller: _cursoIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID del Curso',
                  hintText: 'Ej: 1',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _cursoId = value.isEmpty ? null : int.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 16),

              // Filtro por ID de usuario
              TextField(
                controller: _usuarioIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID del Usuario',
                  hintText: 'Ej: 1',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _usuarioId = value.isEmpty ? null : int.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 16),

              // Filtro por estado de completado
              const Text(
                'Estado de Completado',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Todos'),
                    selected: _completado == null,
                    onSelected: (selected) {
                      setState(() {
                        _completado = null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('En Progreso'),
                    selected: _completado == false,
                    onSelected: (selected) {
                      setState(() {
                        _completado = false;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Completados'),
                    selected: _completado == true,
                    onSelected: (selected) {
                      setState(() {
                        _completado = true;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _cursoId = null;
                          _usuarioId = null;
                          _completado = null;
                          _cursoIdController.clear();
                          _usuarioIdController.clear();
                        });
                        widget.onClearFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Limpiar Filtros'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApplyFilters(
                          cursoId: _cursoId,
                          usuarioId: _usuarioId,
                          completado: _completado,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
