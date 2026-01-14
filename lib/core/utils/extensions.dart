import 'package:flutter/material.dart';

/// Extensiones para String
extension StringExtensions on String {
  /// Valida si es un email válido
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }
  
  /// Valida si es una URL válida
  bool get isValidUrl {
    return RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    ).hasMatch(this);
  }
  
  /// Capitaliza primera letra
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
  
  /// Capitaliza primera letra de cada palabra
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// Remueve espacios en blanco
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
  
  /// Valida si es numérico
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
}

/// Extensiones para DateTime
extension DateTimeExtensions on DateTime {
  /// Verifica si es hoy
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Verifica si es ayer
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
  
  /// Verifica si es en el futuro
  bool get isFuture {
    return isAfter(DateTime.now());
  }
  
  /// Verifica si es en el pasado
  bool get isPast {
    return isBefore(DateTime.now());
  }
  
  /// Obtiene el inicio del día (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }
  
  /// Obtiene el final del día (23:59:59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }
  
  /// Agrega días
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }
  
  /// Resta días
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }
}

/// Extensiones para BuildContext
extension BuildContextExtensions on BuildContext {
  /// Obtiene el MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Obtiene el ancho de la pantalla
  double get width => mediaQuery.size.width;
  
  /// Obtiene el alto de la pantalla
  double get height => mediaQuery.size.height;
  
  /// Obtiene el Theme
  ThemeData get theme => Theme.of(this);
  
  /// Obtiene el TextTheme
  TextTheme get textTheme => theme.textTheme;
  
  /// Obtiene el ColorScheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Muestra un SnackBar
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Muestra un SnackBar de éxito
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }
  
  /// Muestra un SnackBar de error
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
    );
  }
  
  /// Muestra un SnackBar de información
  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.blue,
    );
  }
  
  /// Navega a una página
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  /// Navega y reemplaza la página actual
  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, dynamic>(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  /// Navega y elimina todas las páginas anteriores
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }
  
  /// Retrocede
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}

/// Extensiones para List
extension ListExtensions<T> on List<T> {
  /// Verifica si la lista no es nula ni vacía
  bool get isNotNullOrEmpty {
    return isNotEmpty;
  }
  
  /// Obtiene un elemento seguro (no lanza excepción si el índice es inválido)
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

/// Extensiones para double
extension DoubleExtensions on double {
  /// Redondea a N decimales
  double roundToDecimals(int decimals) {
    final mod = 10.0 * decimals;
    return (this * mod).round() / mod;
  }
  
  /// Convierte a porcentaje (0.75 -> 75)
  double toPercentage() {
    return this * 100;
  }
}

/// Extensiones para int
extension IntExtensions on int {
  /// Convierte segundos a Duration
  Duration get seconds => Duration(seconds: this);
  
  /// Convierte minutos a Duration
  Duration get minutes => Duration(minutes: this);
  
  /// Convierte horas a Duration
  Duration get hours => Duration(hours: this);
  
  /// Convierte días a Duration
  Duration get days => Duration(days: this);
}
