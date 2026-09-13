/// Human-readable application failures. Never expose stack traces to users.
sealed class AppFailure {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([
    super.message =
        'Unable to reach the server. Check your connection and try again.',
  ]);
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure([
    super.message = 'The request timed out. Please try again.',
  ]);
}

final class ServerFailure extends AppFailure {
  const ServerFailure([
    super.message = 'The server encountered an error. Please try again later.',
  ]);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class FileFailure extends AppFailure {
  const FileFailure([
    super.message = 'A file operation failed. Please try again.',
  ]);
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
