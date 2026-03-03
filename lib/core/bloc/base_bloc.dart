import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/logger_service.dart';

/// BaseBloc cung cấp logging tự động cho Event, State changes, và Errors.
/// Tất cả Bloc trong dự án nên kế thừa class này.
abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  @override
  void onEvent(E event) {
    super.onEvent(event);
    AppLogger.i('📩 [$runtimeType] Event: $event');
  }

  @override
  void onChange(Change<S> change) {
    super.onChange(change);
    AppLogger.d('🔄 [$runtimeType] ${change.currentState.runtimeType} → ${change.nextState.runtimeType}');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    AppLogger.e('❌ [$runtimeType] Unhandled Error', error: error, stackTrace: stackTrace);
    super.onError(error, stackTrace);
  }
}

