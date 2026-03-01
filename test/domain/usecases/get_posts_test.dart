import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:base_flutter/core/error/failure.dart';
import 'package:base_flutter/core/usecases/usecase.dart';
import 'package:base_flutter/core/utils/result.dart';
import 'package:base_flutter/domain/entities/post.dart';
import 'package:base_flutter/domain/repositories/post_repository.dart';
import 'package:base_flutter/domain/usecases/get_posts.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPosts usecase;
  late MockPostRepository mockRepository;

  final tPosts = [
    const Post(id: 1, title: 'Title 1', body: 'Body 1'),
  ];

  setUp(() {
    mockRepository = MockPostRepository();
    usecase = GetPosts(mockRepository);
  });

  test('phải gọi repository.getPosts() và trả về danh sách post', () async {
    when(() => mockRepository.getPosts())
        .thenAnswer((_) async => Success(tPosts));

    final result = await usecase(NoParams());

    expect(result.isSuccess, true);
    result.fold(
      (_) => fail('Không nên có failure'),
      (posts) => expect(posts, tPosts),
    );
    verify(() => mockRepository.getPosts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('phải trả về Failure khi repository thất bại', () async {
    when(() => mockRepository.getPosts()).thenAnswer(
        (_) async => const FailureResult(ServerFailure('Lỗi server')));

    final result = await usecase(NoParams());

    expect(result.isFailure, true);
    result.fold(
      (failure) => expect(failure.message, 'Lỗi server'),
      (_) => fail('Không nên có success'),
    );
  });
}
