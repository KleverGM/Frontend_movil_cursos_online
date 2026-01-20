import 'package:dio/dio.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/section_model.dart';

abstract class SectionRemoteDataSource {
  Future<List<SectionModel>> getSectionsByModule(int moduleId);
  Future<SectionModel> getSectionDetail(int sectionId);
  Future<SectionModel> createSection({
    required int moduloId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    PlatformFile? videoFile,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview,
  });
  Future<SectionModel> updateSection({
    required int sectionId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    PlatformFile? videoFile,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview,
  });
  Future<void> deleteSection(int sectionId);
}

class SectionRemoteDataSourceImpl implements SectionRemoteDataSource {
  final ApiClient _apiClient;

  SectionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SectionModel>> getSectionsByModule(int moduleId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.sections,
        queryParameters: {'modulo': moduleId},
      );

      final List<dynamic> data = response.data is List
          ? response.data as List<dynamic>
          : (response.data as Map<String, dynamic>)['results'] as List<dynamic>;
      
      return data.map((json) => SectionModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error al obtener secciones: $e');
    }
  }

  @override
  Future<SectionModel> getSectionDetail(int sectionId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.sections}$sectionId/');
      return SectionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener detalle de sección: $e');
    }
  }

  @override
  Future<SectionModel> createSection({
    required int moduloId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    PlatformFile? videoFile,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview = false,
  }) async {
    try {
      // Si hay video file o archivo, usar FormData
      if ((videoFile != null) || (archivoPath != null && archivoPath.isNotEmpty)) {
        final formData = FormData.fromMap({
          'modulo': moduloId,
          'titulo': titulo,
          'contenido': contenido,
          'orden': orden,
          'duracion_minutos': duracionMinutos,
          'es_preview': esPreview,
        });

        // Agregar video file si existe
        if (videoFile != null) {
          if (videoFile.path != null) {
            // Plataformas con path (Android, iOS)
            formData.files.add(MapEntry(
              'video_file',
              await MultipartFile.fromFile(
                videoFile.path!,
                filename: videoFile.name,
              ),
            ));
          } else if (videoFile.bytes != null) {
            // Web - usar bytes
            formData.files.add(MapEntry(
              'video_file',
              MultipartFile.fromBytes(
                videoFile.bytes!,
                filename: videoFile.name,
              ),
            ));
          }
        }

        // Agregar archivo si existe
        if (archivoPath != null && archivoPath.isNotEmpty) {
          formData.files.add(MapEntry(
            'archivo',
            await MultipartFile.fromFile(
              archivoPath,
              filename: archivoPath.split('/').last,
            ),
          ));
        }

        // Agregar URL si existe
        if (videoUrl != null && videoUrl.isNotEmpty) {
          formData.fields.add(MapEntry('video_url', videoUrl));
        }

        final response = await _apiClient.dio.post(
          ApiConstants.sections,
          data: formData,
        );

        return SectionModel.fromJson(response.data);
      }

      // Sin archivo, usar JSON normal
      final data = {
        'modulo': moduloId,
        'titulo': titulo,
        'contenido': contenido,
        'orden': orden,
        'duracion_minutos': duracionMinutos,
        'es_preview': esPreview,
      };

      if (videoUrl != null && videoUrl.isNotEmpty) {
        data['video_url'] = videoUrl;
      }

      final response = await _apiClient.dio.post(
        ApiConstants.sections,
        data: data,
      );

      return SectionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear sección: $e');
    }
  }

  @override
  Future<SectionModel> updateSection({
    required int sectionId,
    required String titulo,
    required String contenido,
    String? videoUrl,
    PlatformFile? videoFile,
    String? archivoPath,
    required int orden,
    required int duracionMinutos,
    bool esPreview = false,
  }) async {
    try {
      // Si hay video file o archivo, usar FormData
      if ((videoFile != null) || (archivoPath != null && archivoPath.isNotEmpty && File(archivoPath).existsSync())) {
        final formData = FormData.fromMap({
          'titulo': titulo,
          'contenido': contenido,
          'orden': orden,
          'duracion_minutos': duracionMinutos,
          'es_preview': esPreview,
        });

        // Agregar video file si existe
        if (videoFile != null) {
          if (videoFile.path != null) {
            // Plataformas con path
            formData.files.add(MapEntry(
              'video_file',
              await MultipartFile.fromFile(
                videoFile.path!,
                filename: videoFile.name,
              ),
            ));
          } else if (videoFile.bytes != null) {
            // Web
            formData.files.add(MapEntry(
              'video_file',
              MultipartFile.fromBytes(
                videoFile.bytes!,
                filename: videoFile.name,
              ),
            ));
          }
        }

        // Agregar archivo si existe
        if (archivoPath != null && archivoPath.isNotEmpty) {
          formData.files.add(MapEntry(
            'archivo',
            await MultipartFile.fromFile(
              archivoPath,
              filename: archivoPath.split('/').last,
            ),
          ));
        }

        // Agregar URL si existe
        if (videoUrl != null && videoUrl.isNotEmpty) {
          formData.fields.add(MapEntry('video_url', videoUrl));
        }

        final response = await _apiClient.dio.patch(
          '${ApiConstants.sections}$sectionId/',
          data: formData,
        );

        return SectionModel.fromJson(response.data);
      }

      // Sin archivo nuevo, usar JSON normal
      final data = <String, dynamic>{
        'titulo': titulo,
        'contenido': contenido,
        'orden': orden,
        'duracion_minutos': duracionMinutos,
        'es_preview': esPreview,
      };

      if (videoUrl != null && videoUrl.isNotEmpty) {
        data['video_url'] = videoUrl;
      }

      final response = await _apiClient.dio.patch(
        '${ApiConstants.sections}$sectionId/',
        data: data,
      );

      return SectionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar sección: $e');
    }
  }

  @override
  Future<void> deleteSection(int sectionId) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.sections}$sectionId/');
    } catch (e) {
      throw Exception('Error al eliminar sección: $e');
    }
  }
}
