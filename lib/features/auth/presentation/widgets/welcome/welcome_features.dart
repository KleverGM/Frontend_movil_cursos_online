import 'package:flutter/material.dart';

/// Widget de características de la plataforma
class WelcomeFeatures extends StatelessWidget {
  const WelcomeFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeatureItem(
          icon: Icons.video_library,
          title: 'Cursos variados',
          description: 'Accede a cientos de cursos en diferentes categorías',
          color: Colors.blue,
        ),
        const SizedBox(height: 24),
        _FeatureItem(
          icon: Icons.schedule,
          title: 'Aprende a tu ritmo',
          description: 'Estudia cuando y donde quieras, sin horarios fijos',
          color: Colors.orange,
        ),
        const SizedBox(height: 24),
        _FeatureItem(
          icon: Icons.workspace_premium,
          title: 'Certificados',
          description: 'Obtén certificados al completar tus cursos',
          color: Colors.green,
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icono
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Texto
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
