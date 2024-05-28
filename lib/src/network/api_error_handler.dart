import 'package:dio/dio.dart';
import 'package:md_framework/md_framework.dart';

class ApiErrorHandler {
  static MDResponse getError(DioException d) {
    if (d.response == null) {
      return MDResponse.a(status: '500', message: 'No Internet Connection');

    }

    if (d.type == DioExceptionType.receiveTimeout) {
      return MDResponse.a(status: '408', message: 'Connection Timeout');
    }

    switch (d.response!.statusCode) {
      case 401:
        return MDResponse.a(status: '401', message: 'Unauthorized');
      case 500:
        return MDResponse.a(status: '500', message: 'Connection Error');
      case 404:
        return MDResponse.a(status: '404', message: 'Not Found');
      case 408:
        return MDResponse.a(status: '408', message: 'Connection Timeout');
      default:
        return MDResponse.a(status: '500', message: 'Connection Error');
    }
  }
}
