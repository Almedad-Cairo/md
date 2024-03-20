import 'package:dio/dio.dart';
import 'package:md/src/api_constants.dart';
import 'package:md/src/md/data/repo/md_repo.dart';
import 'package:md/src/network/api_service.dart';
import 'package:md/src/network/dio_factory.dart';
import 'package:get_it/get_it.dart';

class GetItInitializer {
  static final _getIt = GetIt.instance;
  static void init( ) {
    Dio dio = DioFactory.getDio();
    _getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
    _getIt.registerLazySingleton<MDRepo>(() => MDRepo(_getIt()));
    _getIt.registerLazySingleton<ApiConstants>(() => ApiConstants() );

  }
  static T get<T>() {
    return _getIt<T>();
  }


}

T get<T>() {
  return GetItInitializer.get<T>();
}
