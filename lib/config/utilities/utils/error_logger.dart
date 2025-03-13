import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/errors/app_exception.dart';

class ErrorLogger {
  static AppException handleDioError(DioException e) {
    log(
      "🌐 Dio Error: ${e.message} (Status Code: ${e.response?.statusCode})",
      name: "DioService",
      error: e,
      stackTrace: StackTrace.current,
    );

    // You could add switch/case logic based on e.response?.statusCode here
    return DioExceptionCustom(e.message ?? "Unknown Dio Error");
  }

  /// 📌 Generic error logging (e.g. non-200 status codes)
  static void logGenericError(String methodName, String message) {
    log(
      "🚨 Generic Error in [$methodName]: $message",
      name: "GenericError",
      stackTrace: StackTrace.current,
    );
  }

  /// 📌 Hive error logging
  static AppException handleHiveError(HiveError e) {
    log(
      "🐝 Hive Error: ${e.message}",
      name: "HiveError",
      error: e,
      stackTrace: StackTrace.current,
    );

    return HiveExceptionCustom(e.message);
  }
}
