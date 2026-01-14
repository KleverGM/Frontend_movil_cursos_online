import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Clase para verificar la conectividad a internet
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl({
    required Connectivity connectivity,
    required InternetConnectionChecker connectionChecker,
  })  : _connectivity = connectivity,
        _connectionChecker = connectionChecker;

  @override
  Future<bool> get isConnected async {
    // Primero verificar si hay una conexión de red disponible
    final connectivityResult = await _connectivity.checkConnectivity();
    
    // Si no hay conexión de red, retornar false inmediatamente
    // checkConnectivity() retorna List<ConnectivityResult>
    if (connectivityResult is List) {
      if ((connectivityResult as List).contains(ConnectivityResult.none)) {
        return false;
      }
    } else {
      // Para versiones anteriores que retornan un solo valor
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
    }

    // Si hay conexión de red, verificar si realmente hay acceso a internet
    try {
      return await _connectionChecker.hasConnection;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((result) async {
      // Si no hay conexión de red
      // onConnectivityChanged puede emitir List o valor individual según versión
      bool hasNoConnection;
      if (result is List) {
        hasNoConnection = (result as List).contains(ConnectivityResult.none);
      } else {
        hasNoConnection = result == ConnectivityResult.none;
      }

      if (hasNoConnection) {
        return false;
      }

      // Si hay conexión de red, verificar internet real
      try {
        return await _connectionChecker.hasConnection;
      } catch (e) {
        return false;
      }
    });
  }
}
