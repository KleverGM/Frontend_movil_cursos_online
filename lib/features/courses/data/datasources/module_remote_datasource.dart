import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/module_model.dart';

/// DataSource remoto para módulos
abstract class ModuleRemoteDataSource {
  Future<List<ModuleModel>> getModulesByCourse(int courseId);
  Future<ModuleModel> createModule({
    required int cursoId,
    required String titulo,
    String? descripcion,
    required int orden,
  });
  Future<ModuleModel> updateModule({
    required int moduleId,
    required String titulo,
    String? descripcion,
    required int orden,
  });
  Future<void> deleteModule(int moduleId);
  Future<void> reorderModules({
    required int courseId,
    required List<int> moduleIds,
  });
}

class ModuleRemoteDataSourceImpl implements ModuleRemoteDataSource {
  final ApiClient _apiClient;

  ModuleRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ModuleModel>> getModulesByCourse(int courseId) async {
    final response = await _apiClient.get(
      ApiConstants.modules,
      queryParameters: {'curso': courseId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List
          ? response.data as List<dynamic>
          : (response.data as Map<String, dynamic>)['results'] as List<dynamic>;
      
      return data.map((json) => ModuleModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener módulos: ${response.statusCode}');
    }
  }

  @override
  Future<ModuleModel> createModule({
    required int cursoId,
    required String titulo,
    String? descripcion,
    required int orden,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.modules,
        data: {
          'curso': cursoId,
          'titulo': titulo,
          'descripcion': descripcion,
          'orden': orden,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ModuleModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Error al crear módulo: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('curso') && e.toString().contains('orden')) {
        throw Exception('Ya existe un módulo con este orden en el curso');
      }
      rethrow;
    }
  }

  @override
  Future<ModuleModel> updateModule({
    required int moduleId,
    required String titulo,
    String? descripcion,
    required int orden,
  }) async {
    try {
      final response = await _apiClient.patch(
        '${ApiConstants.modules}$moduleId/',
        data: {
          'titulo': titulo,
          'descripcion': descripcion,
          'orden': orden,
        },
      );

      if (response.statusCode == 200) {
        return ModuleModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Error al actualizar módulo: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('unique') || 
          (e.toString().contains('curso') && e.toString().contains('orden'))) {
        throw Exception('Ya existe un módulo con orden $orden. Elige otro número.');
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteModule(int moduleId) async {
    final response = await _apiClient.delete(
      '${ApiConstants.modules}$moduleId/',
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar módulo: ${response.statusCode}');
    }
  }

  @override
  Future<void> reorderModules({
    required int courseId,
    required List<int> moduleIds,
  }) async {
    final response = await _apiClient.post(
      '${ApiConstants.modules}reordenar/',
      data: {
        'curso': courseId,
        'orden': moduleIds,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al reordenar módulos: ${response.statusCode}');
    }
  }
}
