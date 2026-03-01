import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:base_flutter/core/error/exception.dart';
import 'package:base_flutter/core/network/api_client.dart';
import 'package:base_flutter/data/datasources/post_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late PostRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = PostRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  final tJsonList = [
    {'id': 1, 'title': 'Title 1', 'body': 'Body 1'},
    {'id': 2, 'title': 'Title 2', 'body': 'Body 2'},
  ];

  test('phải trả về List<PostModel> khi response hợp lệ', () async {
    when(() => mockApiClient.get('/posts')).thenAnswer(
      (_) async => Response(
        data: tJsonList,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/posts'),
      ),
    );

    final result = await dataSource.getPosts();

    expect(result.length, 2);
    expect(result[0].id, 1);
    expect(result[0].title, 'Title 1');
  });

  test('phải throw ServerException khi response.data không phải List', () async {
    when(() => mockApiClient.get('/posts')).thenAnswer(
      (_) async => Response(
        data: {'error': 'Invalid'},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/posts'),
      ),
    );

    expect(() => dataSource.getPosts(), throwsA(isA<ServerException>()));
  });

  test('phải rethrow ServerException từ apiClient', () async {
    when(() => mockApiClient.get('/posts'))
        .thenThrow(ServerException(message: 'Lỗi server', statusCode: 500));

    expect(() => dataSource.getPosts(), throwsA(isA<ServerException>()));
  });

  test('phải rethrow NetworkException từ apiClient', () async {
    when(() => mockApiClient.get('/posts'))
        .thenThrow(NetworkException(message: 'Timeout'));

    expect(() => dataSource.getPosts(), throwsA(isA<NetworkException>()));
  });
}
