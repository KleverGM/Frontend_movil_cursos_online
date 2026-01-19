import 'dart:convert';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/review_model.dart';
import '../models/review_stats_model.dart';
import '../models/review_response_model.dart';
import '../../domain/entities/review_response.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import 'review_remote_datasource.dart';

/// Implementación mejorada del DataSource remoto para reseñas con procesamiento de respuestas
class ReviewRemoteDataSourceImprovedImpl implements ReviewRemoteDataSource {
  final ApiClient _apiClient;
  final AuthLocalDataSource _authLocalDataSource;

  ReviewRemoteDataSourceImprovedImpl(this._apiClient, this._authLocalDataSource);

  @override
  Future<List<ReviewModel>> getCourseReviews(int cursoId) async {
    final response = await _apiClient.get(
      ApiConstants.reviews,
      queryParameters: {'curso_id': cursoId},
    );

    if (response.statusCode == 200) {
      final responseData = response.data;
      final List<dynamic> data;

      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        data = responseData['results'] as List<dynamic>;
      } else {
        data = responseData as List<dynamic>;
      }

      return Future.wait(
        data.map((json) => _processReviewJson(json as Map<String, dynamic>)).toList()
      );
    } else {
      throw ServerException(
        'Error al obtener reseñas: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  @override
  Future<ReviewStatsModel> getCourseReviewStats(int cursoId) async {
    final response = await _apiClient.get(
      ApiConstants.courseReviewStats,
      queryParameters: {'curso_id': cursoId},
    );

    if (response.statusCode == 200) {
      return ReviewStatsModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw ServerException(
        'Error al obtener estadísticas: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  @override
  Future<ReviewModel> createReview({
    required int cursoId,
    required int calificacion,
    required String comentario,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.reviews,
      data: {
        'curso_id': cursoId,
        'rating': calificacion,
        'comentario': comentario,
      },
    );

    if (response.statusCode == 201) {
      return _processReviewJson(response.data as Map<String, dynamic>);
    } else {
      throw ServerException(
        'Error al crear reseña: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  @override
  Future<ReviewModel> updateReview({
    required String reviewId,
    required int calificacion,
    required String comentario,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.reviewDetail(reviewId),
      data: {
        'rating': calificacion,
        'comentario': comentario,
      },
    );

    if (response.statusCode == 200) {
      return _processReviewJson(response.data as Map<String, dynamic>);
    } else {
      throw ServerException(
        'Error al actualizar reseña: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  @override
  Future<List<ReviewModel>> getMyReviews() async {
    final response = await _apiClient.get(ApiConstants.myReviews);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List
          ? response.data as List<dynamic>
          : (response.data as Map<String, dynamic>)['results'] as List<dynamic>;

      // Para "mis reseñas", el usuario actual ES el instructor
      // Marcar todas las respuestas como del instructor
      return Future.wait(
        data
          .map((json) => _processInstructorReviewJson(json as Map<String, dynamic>))
          .toList()
      );
    } else {
      throw ServerException(
        'Error al obtener mis reseñas: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final response = await _apiClient.delete(
      ApiConstants.reviewDetail(reviewId),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException(
        'Error al eliminar reseña: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  @override
  Future<void> markReviewHelpful(String reviewId) async {
    final response = await _apiClient.post(
      ApiConstants.markReviewHelpful(reviewId),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        'Error al marcar reseña como útil: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  @override
  Future<ReviewModel> replyToReview(String reviewId, String respuesta) async {
    final response = await _apiClient.post(
      ApiConstants.replyReview(reviewId),
      data: {'texto': respuesta},
    );

    if (response.statusCode == 201) {
      return _processReviewJson(response.data as Map<String, dynamic>);
    } else {
      throw ServerException(
        'Error al responder reseña: ${response.statusMessage}',
        response.statusCode ?? 500,
      );
    }
  }

  /// Procesa el JSON de una reseña para mapear correctamente las respuestas del instructor
  Future<ReviewModel> _processReviewJson(Map<String, dynamic> json) async {
    // Obtener el ID del usuario actual para identificar respuestas del instructor
    final currentUser = await _authLocalDataSource.getCachedUser();
    int? currentUserId = currentUser?.id;
    
    // Si no hay usuario en caché, intentar obtener del token JWT
    if (currentUserId == null) {
      final token = await _authLocalDataSource.getAccessToken();
      if (token != null) {
        try {
          // Decodificar token JWT para obtener user_id
          final parts = token.split('.');
          if (parts.length == 3) {
            final payload = parts[1];
            // Agregar padding si es necesario
            final normalizedPayload = payload.padRight(
              (payload.length + 3) ~/ 4 * 4,
              '=',
            );
            final decodedBytes = base64Decode(normalizedPayload);
            final decodedString = utf8.decode(decodedBytes);
            final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
            currentUserId = payloadMap['user_id'] as int?;
          }
        } catch (e) {
          // Silently fail if token decoding fails
        }
      }
    }

    // Procesar las respuestas con el contexto del instructor
    List<ReviewResponse> respuestasList = [];
    String? respuestaInstructor;
    DateTime? fechaRespuesta;
    
    // Intentar obtener instructor ID del curso si currentUserId es null
    final instructorIdToUse = currentUserId ?? (json['curso_instructor_id'] as int?);
    
    final respuestas = json['respuestas'] as List?;
    if (respuestas != null && respuestas.isNotEmpty) {
      // Convertir todas las respuestas
      for (final respuestaJson in respuestas) {
        if (respuestaJson is Map<String, dynamic>) {
          final respuestaModel = ReviewResponseModel.fromJson(
            respuestaJson,
            instructorId: instructorIdToUse,
          );
          respuestasList.add(respuestaModel);
        }
      }
      
      // Buscar la respuesta más reciente del instructor para mantener compatibilidad
      final instructorResponses = respuestasList
          .where((r) => r.esDelInstructor)
          .toList();
      
      if (instructorResponses.isNotEmpty) {
        instructorResponses.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
        final latest = instructorResponses.first;
        respuestaInstructor = latest.texto;
        fechaRespuesta = latest.fechaCreacion;
      }
    }
    
    return ReviewModel(
      id: json['id'].toString(),
      cursoId: json['curso_id'] as int,
      cursoTitulo: json['titulo_curso'] as String? ?? 'Curso ${json['curso_id']}',
      estudianteId: json['usuario_id'] as int,
      estudianteNombre: json['nombre_usuario'] as String? ?? 'Anónimo',
      calificacion: (json['rating'] as num).toInt(),
      comentario: json['comentario'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      utilesCount: json['util_count'] as int? ?? 0,
      marcadoUtilPorMi: (json['usuarios_util'] as List?)?.contains(instructorIdToUse) ?? false,
      respuestaInstructor: respuestaInstructor,
      fechaRespuesta: fechaRespuesta,
      respuestas: respuestasList,
    );
  }

  /// Procesa una reseña para "Mis Reseñas" del instructor
  /// Marca TODAS las respuestas como del instructor ya que está en su panel
  Future<ReviewModel> _processInstructorReviewJson(Map<String, dynamic> json) async {
    List<ReviewResponse> respuestasList = [];
    String? respuestaInstructor;
    DateTime? fechaRespuesta;
    
    final respuestas = json['respuestas'] as List?;
    if (respuestas != null && respuestas.isNotEmpty) {
      // Convertir todas las respuestas y marcarlas como del instructor
      for (final respuestaJson in respuestas) {
        if (respuestaJson is Map<String, dynamic>) {
          // Crear la respuesta marcándola siempre como del instructor
          final respuestaModel = ReviewResponseModel(
            usuarioId: respuestaJson['usuario_id'] as int,
            texto: respuestaJson['texto'] as String,
            fechaCreacion: DateTime.parse(respuestaJson['fecha'] as String),
            esDelInstructor: true, // Siempre true en "mis reseñas"
          );
          respuestasList.add(respuestaModel);
        }
      }
      
      // La respuesta más reciente (todas son del instructor en este caso)
      if (respuestasList.isNotEmpty) {
        respuestasList.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
        final latest = respuestasList.first;
        respuestaInstructor = latest.texto;
        fechaRespuesta = latest.fechaCreacion;
      }
    }
    
    return ReviewModel(
      id: json['id'].toString(),
      cursoId: json['curso_id'] as int,
      cursoTitulo: json['titulo_curso'] as String? ?? 'Curso ${json['curso_id']}',
      estudianteId: json['usuario_id'] as int,
      estudianteNombre: json['nombre_usuario'] as String? ?? 'Anónimo',
      calificacion: (json['rating'] as num).toInt(),
      comentario: json['comentario'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      utilesCount: json['util_count'] as int? ?? 0,
      marcadoUtilPorMi: false, // No aplica para instructor
      respuestaInstructor: respuestaInstructor,
      fechaRespuesta: fechaRespuesta,
      respuestas: respuestasList,
    );
  }
}