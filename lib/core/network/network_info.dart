import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  /// Returns true if there is an active internet connection.
  Future<bool> get isConnected;

  /// Stream to listen for real-time connectivity changes.
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }
}
