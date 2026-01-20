import 'package:flutter/material.dart';

/// Widget para mostrar racha de aprendizaje (días consecutivos)
class LearningStreakWidget extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final List<int> last7DaysActivity; // 0 o 1 para cada día

  const LearningStreakWidget({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.last7DaysActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.orange[700], size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Racha de Aprendizaje',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Racha actual
            Center(
              child: Column(
                children: [
                  Text(
                    '$currentStreak',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                  Text(
                    currentStreak == 1 ? 'día' : 'días',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¡Sigue así! 🔥',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Últimos 7 días
            const Text(
              'Últimos 7 días',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final isActive = index < last7DaysActivity.length && 
                                 last7DaysActivity[index] > 0;
                final dayLabels = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];
                final dayIndex = (DateTime.now().weekday - 7 + index) % 7;
                
                return Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isActive ? Icons.check : Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayLabels[dayIndex],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              }),
            ),
            
            const SizedBox(height: 20),
            
            // Mejor racha
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity( 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity( 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mejor racha',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$longestStreak ${longestStreak == 1 ? "día" : "días"}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
