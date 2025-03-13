
import '../errors/app_exception.dart';

abstract class DataState<T> {
  final T? data;
  final String? message;

  const DataState({this.data, this.message});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  final AppException exception;

  DataFailed({
    required this.exception,
  }) : super(message: exception.message);
}
