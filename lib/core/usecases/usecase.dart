import 'package:equatable/equatable.dart';

import '../error/failure.dart';
import '../utils/result.dart';

abstract class UseCase<T, Params> {
  Future<Result<T, Failure>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
