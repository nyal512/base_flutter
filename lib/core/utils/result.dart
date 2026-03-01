/// A simple implementation of the Result pattern to handle success and failure without relying on external packages like dartz.
sealed class Result<S, F> {
  const Result();

  // Pattern matching
  T fold<T>(T Function(F failure) onFailure, T Function(S success) onSuccess);

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is FailureResult<S, F>;
}

class Success<S, F> extends Result<S, F> {
  final S value;
  const Success(this.value);

  @override
  T fold<T>(T Function(F failure) onFailure, T Function(S success) onSuccess) {
    return onSuccess(value);
  }
}

class FailureResult<S, F> extends Result<S, F> {
  final F failure;
  const FailureResult(this.failure);

  @override
  T fold<T>(T Function(F failure) onFailure, T Function(S success) onSuccess) {
    return onFailure(failure);
  }
}
