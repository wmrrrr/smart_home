import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final _connectivity = Connectivity();

  Stream<bool> get onStatusChange => _connectivity.onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
