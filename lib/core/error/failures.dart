import 'error_messages.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = ErrorMessages.serverError]);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = ErrorMessages.connectionError]);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([
    super.message = ErrorMessages.authenticationError,
  ]);
}
