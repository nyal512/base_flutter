import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:base_flutter/core/error/failure.dart';
import 'package:base_flutter/core/usecases/usecase.dart';
import 'package:base_flutter/core/utils/result.dart';
import 'package:base_flutter/domain/entities/post.dart';
import 'package:base_flutter/domain/usecases/get_posts.dart';
import 'package:base_flutter/presentation/views/home/bloc/home_bloc.dart';
import 'package:base_flutter/presentation/views/home/bloc/home_event.dart';
import 'package:base_flutter/presentation/views/home/bloc/home_state.dart';

class MockGetPosts extends Mock implements GetPosts {}

void main() {
  late HomeBloc homeBloc;
  late MockGetPosts mockGetPosts;

  final tPosts = [
    const Post(id: 1, title: 'Test Title 1', body: 'Test Body 1'),
    const Post(id: 2, title: 'Test Title 2', body: 'Test Body 2'),
  ];

  setUp(() {
    mockGetPosts = MockGetPosts();
    homeBloc = HomeBloc(getPosts: mockGetPosts);
  });

  tearDown(() => homeBloc.close());

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  test('initialState phải là HomeInitial', () {
    expect(homeBloc.state, const HomeState.initial());
  });

  group('FetchPostsEvent', () {
    test(
      'emit [loading, loaded] khi getPosts thành công',
      () async {
        // arrange
        when(() => mockGetPosts(any()))
            .thenAnswer((_) async => Success(tPosts));

        // assert later
        final expectedStates = [
          const HomeState.loading(),
          HomeState.loaded(posts: tPosts),
        ];
        expectLater(homeBloc.stream, emitsInOrder(expectedStates));

        // act
        homeBloc.add(FetchPostsEvent());
      },
    );

    test(
      'emit [loading, error] khi getPosts trả về ServerFailure',
      () async {
        // arrange
        when(() => mockGetPosts(any())).thenAnswer(
            (_) async => const FailureResult(ServerFailure('Lỗi server')));

        // assert later
        final expectedStates = [
          const HomeState.loading(),
          const HomeState.error(message: 'Lỗi server'),
        ];
        expectLater(homeBloc.stream, emitsInOrder(expectedStates));

        // act
        homeBloc.add(FetchPostsEvent());
      },
    );

    test(
      'emit [loading, error] khi getPosts trả về NetworkFailure',
      () async {
        // arrange
        when(() => mockGetPosts(any())).thenAnswer(
            (_) async =>
                const FailureResult(NetworkFailure('Không có kết nối mạng')));

        // assert later
        final expectedStates = [
          const HomeState.loading(),
          const HomeState.error(message: 'Không có kết nối mạng'),
        ];
        expectLater(homeBloc.stream, emitsInOrder(expectedStates));

        // act
        homeBloc.add(FetchPostsEvent());
      },
    );
  });
}
