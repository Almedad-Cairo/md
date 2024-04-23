import 'package:dio/dio.dart';
import 'package:md_framework/md_framework.dart';

class ApiErrorHandler {
  static MDResponse getError(DioException d) {
    if (d.response == null) {
      return MDResponse.a(status: '500', message: 'No Internet Connection');
    } else if (d.response!.statusCode == 401) {
      return MDResponse.a(status: '401', message: 'Unauthorized');
    } else if (d.response!.statusCode == 500) {
      return MDResponse.a(status: '500', message: 'Connection Error');
    } else if (d.response!.statusCode == 404) {
      return MDResponse.a(status: '404', message: 'Not Found');
    } else {
      return MDResponse.a(status: '500', message: 'Connection Error');
    }
  }
}
