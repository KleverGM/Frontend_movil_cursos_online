import '../constants/app_constants.dart';

/// Clase con validadores para formularios
class Validators {
  /// Valida que el campo no esté vacío
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }
  
  /// Valida formato de email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es requerido';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingresa un email válido';
    }
    
    return null;
  }
  
  /// Valida longitud mínima
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    
    if (value.length < minLength) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $minLength caracteres';
    }
    
    return null;
  }
  
  /// Valida longitud máxima
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Este campo'} no puede tener más de $maxLength caracteres';
    }
    
    return null;
  }
  
  /// Valida contraseña
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'La contraseña debe tener al menos ${AppConstants.minPasswordLength} caracteres';
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'La contraseña no puede tener más de ${AppConstants.maxPasswordLength} caracteres';
    }
    
    return null;
  }
  
  /// Valida que las contraseñas coincidan
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }
  
  /// Valida username
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre de usuario es requerido';
    }
    
    if (value.length < AppConstants.minUsernameLength) {
      return 'El nombre de usuario debe tener al menos ${AppConstants.minUsernameLength} caracteres';
    }
    
    if (value.length > AppConstants.maxUsernameLength) {
      return 'El nombre de usuario no puede tener más de ${AppConstants.maxUsernameLength} caracteres';
    }
    
    // Solo letras, números y guion bajo
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Solo se permiten letras, números y guion bajo';
    }
    
    return null;
  }
  
  /// Valida número
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    
    if (double.tryParse(value) == null) {
      return 'Ingresa un número válido';
    }
    
    return null;
  }
  
  /// Valida número positivo
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;
    
    if (double.parse(value!) <= 0) {
      return '${fieldName ?? 'Este campo'} debe ser mayor a 0';
    }
    
    return null;
  }
  
  /// Valida rango numérico
  static String? numberRange(
    String? value,
    double min,
    double max, {
    String? fieldName,
  }) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;
    
    final numberValue = double.parse(value!);
    if (numberValue < min || numberValue > max) {
      return '${fieldName ?? 'Este campo'} debe estar entre $min y $max';
    }
    
    return null;
  }
  
  /// Valida URL
  static String? url(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'La URL'} es requerida';
    }
    
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    
    if (!urlRegex.hasMatch(value.trim())) {
      return 'Ingresa una URL válida';
    }
    
    return null;
  }
  
  /// Valida teléfono
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es requerido';
    }
    
    // Eliminar espacios y caracteres especiales excepto +
    final cleanValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Mínimo 8 dígitos, puede empezar con +
    final phoneRegex = RegExp(r'^\+?[0-9]{8,}$');
    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Ingresa un teléfono válido';
    }
    
    return null;
  }
  
  /// Valida rating (1-5)
  static String? rating(double? value) {
    if (value == null) {
      return 'Selecciona una calificación';
    }
    
    if (value < AppConstants.minRating || value > AppConstants.maxRating) {
      return 'La calificación debe estar entre ${AppConstants.minRating} y ${AppConstants.maxRating}';
    }
    
    return null;
  }
  
  /// Combina múltiples validadores
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
