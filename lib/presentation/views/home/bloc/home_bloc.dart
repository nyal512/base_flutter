import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/usecases/get_posts.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPosts getPosts;

  HomeBloc({required this.getPosts}) : super(const HomeState.initial()) {
    on<FetchPostsEvent>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(FetchPostsEvent event, Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    final result = await getPosts(NoParams());
    
    result.fold(
      (failure) => emit(HomeState.error(message: failure.message)),
      (posts) => emit(HomeState.loaded(posts: posts)),
    );
  }
}
