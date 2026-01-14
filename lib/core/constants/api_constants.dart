/// Constantes para los endpoints de la API
class ApiConstants {
  // Base URL - API desplegada
  static const String baseUrl = 'https://cursos-online-api.desarrollo-software.xyz';
  static const String apiVersion = '/api';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Auth Endpoints
  static const String login = '$apiVersion/users/login/';
  static const String register = '$apiVersion/users/register/';
  static const String refreshToken = '$apiVersion/auth/refresh/';
  static const String tokenVerify = '$apiVersion/auth/token/verify/';
  
  // User Endpoints
  static const String users = '$apiVersion/users/';
  static const String userProfile = '$apiVersion/users/perfil/';
  static const String userStatistics = '$apiVersion/users/estadisticas/';
  
  // Courses Endpoints
  static const String courses = '$apiVersion/cursos/';
  static String courseDetail(int id) => '$apiVersion/cursos/$id/';
  static String courseEnroll(int id) => '$apiVersion/cursos/$id/inscribirse/';
  static const String myCourses = '$apiVersion/cursos/mis_cursos/';
  static const String enrolledCourses = '$apiVersion/inscripciones/';
  
  // Modules Endpoints
  static const String modules = '$apiVersion/modulos/';
  static String moduleDetail(int id) => '$apiVersion/modulos/$id/';
  
  // Sections Endpoints
  static const String sections = '$apiVersion/secciones/';
  static String sectionDetail(int id) => '$apiVersion/secciones/$id/';
  static String markSectionCompleted(int id) => '$apiVersion/secciones/$id/marcar_completado/';
  
  // Enrollments Endpoints
  static const String enrollments = '$apiVersion/inscripciones/';
  static String enrollmentDetail(int id) => '$apiVersion/inscripciones/$id/';
  
  // Reviews Endpoints (MongoDB)
  static const String reviews = '$apiVersion/resenas/';
  static String reviewDetail(String id) => '$apiVersion/resenas/$id/';
  static String markReviewHelpful(String id) => '$apiVersion/resenas/$id/marcar_util/';
  static String replyReview(String id) => '$apiVersion/resenas/$id/responder/';
  static const String myReviews = '$apiVersion/resenas/mis_resenas/';
  static const String courseReviewStats = '$apiVersion/resenas/estadisticas_curso/';
  
  // Notifications Endpoints (MongoDB)
  static const String notifications = '$apiVersion/notificaciones/';
  static const String unreadNotifications = '$apiVersion/notificaciones/no_leidas/';
  static String markNotificationRead(String id) => '$apiVersion/notificaciones/$id/marcar_leida/';
  static const String notificationCounter = '$apiVersion/notificaciones/contador/';
  
  // Avisos Endpoints
  static const String avisos = '$apiVersion/avisos/';
  static String avisoDetail(int id) => '$apiVersion/avisos/$id/';
  static String markAvisoRead(int id) => '$apiVersion/avisos/$id/marcar_leido/';
  
  // Analytics Endpoints (MongoDB)
  static const String analyticsEvents = '$apiVersion/analytics/eventos/';
  static String analyticsEventDetail(String id) => '$apiVersion/analytics/eventos/$id/';
  static const String userStatisticsAnalytics = '$apiVersion/analytics/eventos/estadisticas_usuario/';
  static const String recentEvents = '$apiVersion/analytics/eventos/eventos_recientes/';
  static const String popularCourses = '$apiVersion/analytics/eventos/cursos_populares/';
  
  // WebSocket
  static const String wsBaseUrl = 'wss://cursos-online-api.desarrollo-software.xyz';
  static const String wsNotificationsUrl = '$wsBaseUrl/ws/notifications/';
  static String wsNotifications(String token) => '$wsBaseUrl/ws/notifications/?token=$token';
  
  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}
