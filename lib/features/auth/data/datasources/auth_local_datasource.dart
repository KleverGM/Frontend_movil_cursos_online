import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Datasource local para autenticación
abstract class AuthLocalDataSource {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> saveUser(UserModel user);

  Future<UserModel?> getCachedUser();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearAuth();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  })  : _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: accessToken,
      );
      await _secureStorage.write(
        key: StorageKeys.refreshToken,
        value: refreshToken,
      );
    } catch (e) {
      throw const CacheException('Error al guardar tokens');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _sharedPreferences.setString(
        StorageKeys.userData,
        userJson,
      );
    } catch (e) {
      throw const CacheException('Error al guardar usuario');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _sharedPreferences.getString(StorageKeys.userData);
      if (userJson == null) {
        return null;
      }
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw const CacheException('Error al obtener usuario');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: StorageKeys.accessToken);
    } catch (e) {
      throw const CacheException('Error al obtener access token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: StorageKeys.refreshToken);
    } catch (e) {
      throw const CacheException('Error al obtener refresh token');
    }
  }

  @override
  Future<void> clearAuth() async {
    try {
      await _secureStorage.delete(key: StorageKeys.accessToken);
      await _secureStorage.delete(key: StorageKeys.refreshToken);
      await _sharedPreferences.remove(StorageKeys.userData);
    } catch (e) {
      throw const CacheException('Error al limpiar autenticación');
    }
  }
}
