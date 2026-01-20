import 'package:flutter/material.dart';

import '../../domain/entities/module.dart';

/// Card de módulo expandible con lista de secciones
class ModuleCard extends StatefulWidget {
  final Module modulo;
  final bool inscrito;

  const ModuleCard({
    super.key,
    required this.modulo,
    required this.inscrito,
  });

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final totalSecciones = widget.modulo.secciones.length;
    final duracionTotal = widget.modulo.secciones.fold<int>(
          0,
          (sum, seccion) => sum + seccion.duracionMinutos,
        );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                '${widget.modulo.orden}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              widget.modulo.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$totalSecciones secciones • $duracionTotal min',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
          if (_isExpanded && widget.modulo.secciones.isNotEmpty) ...[
            const Divider(height: 1),
            ...widget.modulo.secciones.map(
              (seccion) => ListTile(
                leading: Icon(
                  seccion.videoUrl != null
                      ? Icons.play_circle_outline
                      : Icons.article_outlined,
                  color: Colors.grey[600],
                ),
                title: Text(seccion.titulo),
                subtitle: Text('${seccion.duracionMinutos} min'),
                trailing: seccion.esPreview == true
                    ? Chip(
                        label: const Text(
                          'Preview',
                          style: TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.blue[100],
                      )
                    : widget.inscrito
                        ? const Icon(Icons.lock_open, color: Colors.green)
                        : const Icon(Icons.lock, color: Colors.grey),
                onTap: widget.inscrito || seccion.esPreview == true
                    ? () {
                        // TODO: Navegar al contenido de la sección
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Abrir: ${seccion.titulo}'),
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
