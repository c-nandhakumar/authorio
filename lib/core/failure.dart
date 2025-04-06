abstract class FailureType {
  final String message;
  FailureType(this.message);
}

class NetworkFailure extends FailureType {
  NetworkFailure(super.message);
}

class ParsingFailure extends FailureType {
  ParsingFailure(super.message);
}

class UnknownFailure extends FailureType {
  UnknownFailure() : super("An unknown error occurred");
}

class TimeoutFailure extends FailureType {
  TimeoutFailure(super.message);
}
