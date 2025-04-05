import 'package:authorio/core/failure.dart';

sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final FailureType failureType;
  Failure(this.failureType);
}
