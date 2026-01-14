/// Claves para almacenamiento local (SharedPreferences y SecureStorage)
class StorageKeys {
  // Secure Storage (tokens y datos sensibles)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  
  // SharedPreferences (configuración y preferencias)
  static const String isFirstTime = 'is_first_time';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userType = 'user_type';
  static const String userAvatar = 'user_avatar';
  static const String userData = 'user_data'; // JSON completo del usuario
  
  // Theme
  static const String themeMode = 'theme_mode'; // 'light', 'dark', 'system'
  
  // Language
  static const String languageCode = 'language_code';
  
  // Notifications
  static const String notificationsEnabled = 'notifications_enabled';
  static const String fcmToken = 'fcm_token';
  
  // Cache
  static const String lastCacheUpdate = 'last_cache_update';
  static const String cachedCoursesKey = 'cached_courses';
  
  // Video Player Settings
  static const String videoQuality = 'video_quality';
  static const String autoPlay = 'auto_play';
  static const String playbackSpeed = 'playback_speed';
  
  // Download Settings
  static const String downloadQuality = 'download_quality';
  static const String wifiOnlyDownload = 'wifi_only_download';
  
  // Analytics
  static const String analyticsEnabled = 'analytics_enabled';
}
