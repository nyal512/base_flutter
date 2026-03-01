class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'No Internet Connection'});
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}
