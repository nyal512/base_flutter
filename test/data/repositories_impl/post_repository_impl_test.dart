import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:base_flutter/core/error/exception.dart';
import 'package:base_flutter/core/error/failure.dart';
import 'package:base_flutter/data/datasources/post_local_data_source.dart';
import 'package:base_flutter/data/datasources/post_remote_data_source.dart';
import 'package:base_flutter/data/models/post_model.dart';
import 'package:base_flutter/data/repositories_impl/post_repository_impl.dart';
import 'package:base_flutter/core/network/network_info.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}
class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late PostRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemote;
  late MockPostLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  final tPostModels = [
    const PostModel(id: 1, title: 'Title 1', body: 'Body 1'),
    const PostModel(id: 2, title: 'Title 2', body: 'Body 2'),
  ];

  setUp(() {
    mockRemote = MockPostRemoteDataSource();
    mockLocal = MockPostLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PostRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('Khi có kết nối mạng', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('phải trả về data từ remote và cache lại', () async {
      when(() => mockRemote.getPosts()).thenAnswer((_) async => tPostModels);
      when(() => mockLocal.cachePosts(any())).thenAnswer((_) async {});

      final result = await repository.getPosts();

      expect(result.isSuccess, true);
      result.fold(
        (_) => fail('Không nên có failure'),
        (posts) => expect(posts, tPostModels),
      );
      verify(() => mockRemote.getPosts()).called(1);
      verify(() => mockLocal.cachePosts(tPostModels)).called(1);
    });

    test('phải trả về ServerFailure khi remote throw ServerException', () async {
      when(() => mockRemote.getPosts())
          .thenThrow(ServerException(message: 'Lỗi 500', statusCode: 500));

      final result = await repository.getPosts();

      expect(result.isFailure, true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Lỗi 500');
        },
        (_) => fail('Không nên có success'),
      );
      verifyNever(() => mockLocal.cachePosts(any()));
    });
  });

  group('Khi không có kết nối mạng', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('phải trả về data từ cache khi offline', () async {
      when(() => mockLocal.getLastPosts()).thenAnswer((_) async => tPostModels);

      final result = await repository.getPosts();

      expect(result.isSuccess, true);
      result.fold(
        (_) => fail('Không nên có failure'),
        (posts) => expect(posts, tPostModels),
      );
      verifyNever(() => mockRemote.getPosts());
      verify(() => mockLocal.getLastPosts()).called(1);
    });

    test(
        'phải trả về NetworkFailure khi offline và không có cache',
        () async {
      when(() => mockLocal.getLastPosts())
          .thenThrow(CacheException(message: 'Không có cache'));

      final result = await repository.getPosts();

      expect(result.isFailure, true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Không nên có success'),
      );
    });
  });
}
