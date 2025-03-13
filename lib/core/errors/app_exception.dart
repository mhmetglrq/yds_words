abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class DioExceptionCustom extends AppException {
  DioExceptionCustom(super.message);
}

class GenericException extends AppException {
  GenericException(super.message);
}

class HiveExceptionCustom extends AppException {
  HiveExceptionCustom(super.message);
}
