/// Constantes generales de la aplicación
class AppConstants {
  // App Info
  static const String appName = 'Cursos Online';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int itemsPerPage = 20;
  static const int itemsPerPageGrid = 6;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  
  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  
  // Progress
  static const int minProgress = 0;
  static const int maxProgress = 100;
  
  // Video
  static const int videoProgressUpdateInterval = 5; // segundos
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCachedCourses = 100;
  
  // Timeouts
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);
  
  // Image
  static const double maxImageSize = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Notifications
  static const int notificationBadgeMax = 99;
  
  // Error Messages
  static const String genericErrorMessage = 'Ha ocurrido un error. Por favor, intenta de nuevo.';
  static const String noInternetMessage = 'Sin conexión a internet. Verifica tu conexión.';
  static const String sessionExpiredMessage = 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';
}

/// Categorías de cursos
class CourseCategories {
  static const String programacion = 'programacion';
  static const String diseno = 'diseno';
  static const String marketing = 'marketing';
  static const String negocios = 'negocios';
  static const String idiomas = 'idiomas';
  static const String musica = 'musica';
  static const String fotografia = 'fotografia';
  static const String otros = 'otros';
  
  static const Map<String, String> categoryNames = {
    programacion: 'Programación',
    diseno: 'Diseño',
    marketing: 'Marketing',
    negocios: 'Negocios',
    idiomas: 'Idiomas',
    musica: 'Música',
    fotografia: 'Fotografía',
    otros: 'Otros',
  };
  
  static const Map<String, String> categoryIcons = {
    programacion: '💻',
    diseno: '🎨',
    marketing: '📊',
    negocios: '💼',
    idiomas: '🌍',
    musica: '🎵',
    fotografia: '📷',
    otros: '📚',
  };
  
  static List<String> get all => categoryNames.keys.toList();
}

/// Niveles de dificultad
class CourseLevels {
  static const String principiante = 'principiante';
  static const String intermedio = 'intermedio';
  static const String avanzado = 'avanzado';
  
  static const Map<String, String> levelNames = {
    principiante: 'Principiante',
    intermedio: 'Intermedio',
    avanzado: 'Avanzado',
  };
  
  static const Map<String, String> levelColors = {
    principiante: '#4CAF50', // Verde
    intermedio: '#FF9800', // Naranja
    avanzado: '#F44336', // Rojo
  };
  
  static List<String> get all => levelNames.keys.toList();
}

/// Tipos de usuario
class UserTypes {
  static const String estudiante = 'estudiante';
  static const String instructor = 'instructor';
  static const String administrador = 'administrador';
  
  static const Map<String, String> typeNames = {
    estudiante: 'Estudiante',
    instructor: 'Instructor',
    administrador: 'Administrador',
  };
}

/// Tipos de notificaciones
class NotificationTypes {
  static const String nuevaInscripcion = 'nueva_inscripcion';
  static const String cursoCompletado = 'curso_completado';
  static const String nuevaResena = 'nueva_resena';
  static const String cursoActualizado = 'curso_actualizado';
  static const String sistema = 'sistema';
  static const String respuestaComentario = 'respuesta_comentario';
  static const String mensajeDirecto = 'mensaje_directo';
  
  static const Map<String, String> typeNames = {
    nuevaInscripcion: 'Nueva Inscripción',
    cursoCompletado: 'Curso Completado',
    nuevaResena: 'Nueva Reseña',
    cursoActualizado: 'Curso Actualizado',
    sistema: 'Sistema',
    respuestaComentario: 'Respuesta a Comentario',
    mensajeDirecto: 'Mensaje Directo',
  };
}

/// Tipos de avisos
class AvisoTypes {
  static const String general = 'general';
  static const String curso = 'curso';
  static const String sistema = 'sistema';
  static const String promocion = 'promocion';
  
  static const Map<String, String> typeNames = {
    general: 'General',
    curso: 'Curso',
    sistema: 'Sistema',
    promocion: 'Promoción',
  };
}

/// Tipos de eventos de analytics
class AnalyticsEventTypes {
  static const String pageView = 'page_view';
  static const String cursoView = 'curso_view';
  static const String seccionView = 'seccion_view';
  static const String videoStart = 'video_start';
  static const String videoComplete = 'video_complete';
  static const String cursoInscripcion = 'curso_inscripcion';
  static const String resenaCreate = 'resena_create';
  static const String search = 'search';
  static const String click = 'click';
  static const String download = 'download';
  static const String login = 'login';
  static const String logout = 'logout';
}
