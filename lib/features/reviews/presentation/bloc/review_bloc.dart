import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_review.dart';
import '../../domain/usecases/delete_review.dart';
import '../../domain/usecases/get_course_review_stats.dart';
import '../../domain/usecases/get_course_reviews.dart';
import '../../domain/usecases/mark_review_helpful.dart';
import '../../domain/usecases/reply_to_review.dart';
import 'review_event.dart';
import 'review_state.dart';

/// BLoC para gestionar el estado de las reseñas
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetCourseReviews _getCourseReviews;
  final GetCourseReviewStats _getCourseReviewStats;
  final CreateReview _createReview;
  final MarkReviewHelpful _markReviewHelpful;
  final DeleteReview _deleteReview;
  final ReplyToReview _replyToReview;

  ReviewBloc(
    this._getCourseReviews,
    this._getCourseReviewStats,
    this._createReview,
    this._markReviewHelpful,
    this._deleteReview,
    this._replyToReview,
  ) : super(const ReviewInitial()) {
    on<GetCourseReviewsEvent>(_onGetCourseReviews);
    on<GetCourseReviewStatsEvent>(_onGetCourseReviewStats);
    on<CreateReviewEvent>(_onCreateReview);
    on<MarkReviewHelpfulEvent>(_onMarkReviewHelpful);
    on<DeleteReviewEvent>(_onDeleteReview);
    on<ReplyToReviewEvent>(_onReplyToReview);
  }

  Future<void> _onGetCourseReviews(
    GetCourseReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewLoading());

    final result = await _getCourseReviews(event.cursoId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsLoaded(reviews)),
    );
  }

  Future<void> _onGetCourseReviewStats(
    GetCourseReviewStatsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _getCourseReviewStats(event.cursoId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (stats) {
        // Si ya hay reviews cargadas, mantenerlas y agregar stats
        if (state is ReviewsLoaded) {
          final currentState = state as ReviewsLoaded;
          emit(ReviewsLoaded(currentState.reviews, stats: stats));
        } else {
          // Si no hay reviews cargadas, emitir solo con stats
          emit(ReviewsLoaded(const [], stats: stats));
        }
      },
    );
  }

  Future<void> _onCreateReview(
    CreateReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewLoading());

    final result = await _createReview(
      CreateReviewParams(
        cursoId: event.cursoId,
        calificacion: event.calificacion,
        comentario: event.comentario,
      ),
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewCreated(review)),
    );
  }

  Future<void> _onMarkReviewHelpful(
    MarkReviewHelpfulEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _markReviewHelpful(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewMarkedHelpful(event.reviewId)),
    );
  }

  Future<void> _onReplyToReview(
    ReplyToReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewLoading());

    final result = await _replyToReview.execute(
      ReplyToReviewParams(
        reviewId: event.reviewId,
        respuesta: event.respuesta,
      ),
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewReplied(review)),
    );
  }

  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _deleteReview(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewDeleted(event.reviewId)),
    );
  }
}
