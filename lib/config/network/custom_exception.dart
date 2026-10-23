class CustomException implements Exception {
  final _message;
  final _prefix;
  final _statusCode;

  CustomException([this._message, this._prefix, this._statusCode]);

  int get statusCode => _statusCode;

  String get prefix => _prefix;

  String get message => _message;

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message, statusCode])
      : super(message, "Error During Communication", statusCode);
}

class BadRequestException extends CustomException {
  BadRequestException([message, statusCode])
      : super(message, "Invalid Request", statusCode);
}

class BadUploadException extends CustomException {
  BadUploadException([message, statusCode])
      : super(message, "Invalid upload file", statusCode);
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message, statusCode])
      : super(message, "Unauthorised", statusCode);
}

class InvalidInputException extends CustomException {
  InvalidInputException([message, statusCode])
      : super(message, "Invalid Input", statusCode);
}

class AccountExistException extends CustomException {
  AccountExistException([message, statusCode])
      : super(message, "Account already exists", statusCode);
}

class AccountNotActiveException extends CustomException {
  AccountNotActiveException([message, statusCode])
      : super(message, "Account not activated", statusCode);
}

class WrongVerificationCodeException extends CustomException {
  WrongVerificationCodeException([message, statusCode])
      : super(message, "Wrong verification code", statusCode);
}

class ChangeAccountPasswordException extends CustomException {
  ChangeAccountPasswordException([message, statusCode])
      : super(message, "Password should be changed", statusCode);
}

class AccountNotFoundException extends CustomException {
  AccountNotFoundException([message, statusCode])
      : super(message, "Account not found", statusCode);
}

class InternalServerErrorException extends CustomException {
  InternalServerErrorException([message, statusCode])
      : super(message, "Internal server error", statusCode);
}

class SessionExpriedException extends CustomException {
  SessionExpriedException([message, statusCode])
      : super(message, "Session Expired", statusCode);
}
