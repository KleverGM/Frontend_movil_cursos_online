import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/review_model.dart';
import '../models/review_stats_model.dart';

/// DataSource remoto para reseñas
abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getCourseReviews(int cursoId);
  Future<ReviewStatsModel> getCourseReviewStats(int cursoId);
  Future<ReviewModel> createReview({
    required int cursoId,
    required int calificacion,
    required String comentario,
  });
  Future<ReviewModel> updateReview({
    required String reviewId,
    required int calificacion,
    required String comentario,
  });
  Future<void> deleteReview(String reviewId);
  Future<void> markReviewHelpful(String reviewId);
  Future<ReviewModel> replyToReview(String reviewId, String respuesta);
  Future<List<ReviewModel>> getMyReviews();
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiClient _apiClient;

  ReviewRemoteDataSourceImpl(this._apiClient);

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

      return data.map((json) => ReviewModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener reseñas: ${response.statusCode}');
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
      throw Exception('Error al obtener estadísticas: ${response.statusCode}');
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
        'rating': calificacion.toDouble(),
        'titulo': 'Reseña',
        'comentario': comentario,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al crear reseña: ${response.statusCode}');
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
        'rating': calificacion.toDouble(),
        'titulo': 'Reseña',
        'comentario': comentario,
      },
    );

    if (response.statusCode == 200) {
      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al actualizar reseña: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final response = await _apiClient.delete(
      ApiConstants.reviewDetail(reviewId),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar reseña: ${response.statusCode}');
    }
  }

  @override
  Future<void> markReviewHelpful(String reviewId) async {
    final response = await _apiClient.post(
      ApiConstants.markReviewHelpful(reviewId),
      data: {},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al marcar reseña como útil: ${response.statusCode}');
    }
  }

  @override  Future<ReviewModel> replyToReview(String reviewId, String respuesta) async {
    final response = await _apiClient.post(
      '${ApiConstants.reviews}$reviewId/responder/',
      data: {'texto': respuesta},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al responder reseña: ${response.statusCode}');
    }
  }

  @override  Future<List<ReviewModel>> getMyReviews() async {
    final response = await _apiClient.get(ApiConstants.myReviews);

    if (response.statusCode == 200) {
      final responseData = response.data;
      final List<dynamic> data;

      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        data = responseData['results'] as List<dynamic>;
      } else {
        data = responseData as List<dynamic>;
      }

      return data.map((json) => ReviewModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener mis reseñas: ${response.statusCode}');
    }
  }
}
