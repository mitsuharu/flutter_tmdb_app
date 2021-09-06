import 'package:http/http.dart' as http;

class CustomError implements Exception {
  final _message;
  final _prefix;

  CustomError([this._message, this._prefix]);

  String toString() {
    if (this._message == null){
      return "$_prefix";
    }
    return "$_prefix: $_message";
  }
}

class NetworkError extends CustomError {
  NetworkError([message]): super(message, "Network failed");
}

class TimeoutError extends CustomError {
  TimeoutError([message]): super(message, "Time out");
}

class FetchDataError extends CustomError {
  FetchDataError([message])
      : super(message, "Error During Communication");
}

class BadRequestError extends CustomError {
  BadRequestError([message=""]) : super(message, "Invalid Request");
}

class UnauthorisedError extends CustomError {
  UnauthorisedError([message=""]) : super(message, "Unauthorised");
}

class InvalidInputError extends CustomError {
  InvalidInputError([message=""]) : super(message, "Invalid Input");
}

class UnknownError extends CustomError {
  UnknownError([message=""]) : super(message, "unknown");
}

void confirmError(http.Response response) {
  switch (response.statusCode) {
    case 200:
      break;
    case 400:
      throw BadRequestError(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedError(response.body.toString());
    case 500:
    default:
      throw FetchDataError(
          'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
  }
}