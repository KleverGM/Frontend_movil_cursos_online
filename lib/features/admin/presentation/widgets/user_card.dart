import 'package:flutter/material.dart';
import '../../domain/entities/user_summary.dart';

class UserCard extends StatelessWidget {
  final UserSummary user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final VoidCallback? onChangePassword;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.onChangePassword,
  });

  Color _getPerfilColor() {
    switch (user.perfil) {
      case 'administrador':
        return Colors.red;
      case 'instructor':
        return Colors.blue;
      case 'estudiante':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPerfilIcon() {
    switch (user.perfil) {
      case 'administrador':
        return Icons.admin_panel_settings;
      case 'instructor':
        return Icons.school;
      case 'estudiante':
        return Icons.person;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar con ícono de perfil
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getPerfilColor().withOpacity( 0.1),
                    child: Icon(
                      _getPerfilIcon(),
                      color: _getPerfilColor(),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Información del usuario
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.nombreCompleto,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Badge de estado
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: user.isActive
                                    ? Colors.green.withOpacity( 0.1)
                                    : Colors.red.withOpacity( 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.isActive ? 'Activo' : 'Inactivo',
                                style: TextStyle(
                                  color: user.isActive ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${user.username}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                user.email,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Badge de perfil y estadísticas
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPerfilColor().withOpacity( 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getPerfilIcon(),
                          size: 16,
                          color: _getPerfilColor(),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          user.perfilFormateado,
                          style: TextStyle(
                            color: _getPerfilColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (user.perfil == 'estudiante' && user.totalCursosInscritos != null)
                    _buildStatChip(
                      Icons.school_outlined,
                      '${user.totalCursosInscritos} cursos',
                      Colors.blue,
                    ),
                  if (user.perfil == 'instructor' && user.totalCursosCreados != null)
                    _buildStatChip(
                      Icons.create_outlined,
                      '${user.totalCursosCreados} cursos',
                      Colors.orange,
                    ),
                  const Spacer(),
                  Text(
                    'Desde ${_formatDate(user.fechaCreacion)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Acciones
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 4,
                runSpacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: onToggleStatus,
                    icon: Icon(
                      user.isActive ? Icons.block : Icons.check_circle,
                      size: 16,
                    ),
                    label: Text(user.isActive ? 'Desactivar' : 'Activar'),
                    style: TextButton.styleFrom(
                      foregroundColor: user.isActive ? Colors.orange : Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  if (onChangePassword != null)
                    TextButton.icon(
                      onPressed: onChangePassword,
                      icon: const Icon(Icons.lock_reset, size: 16),
                      label: const Text('Contraseña'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Eliminar'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity( 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
