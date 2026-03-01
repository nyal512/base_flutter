import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/post.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded({required List<Post> posts}) = HomeLoaded;
  const factory HomeState.error({required String message}) = HomeError;
}
