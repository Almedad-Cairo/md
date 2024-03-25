import 'package:dio/dio.dart';
import 'package:md_framework/src/api_constants.dart';
import 'package:md_framework/src/md/data/repo/md_repo.dart';
import 'package:md_framework/src/network/api_service.dart';
import 'package:md_framework/src/network/dio_factory.dart';
import 'package:get_it/get_it.dart';

class GetItInitializer {
  static final _getIt = GetIt.instance;
  static void init() {
    Dio dio = DioFactory.getDio();
    _getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
    _getIt.registerLazySingleton<MDRepo>(() => MDRepo.a(_getIt()),instanceName: 'md_repo');
    _getIt.registerLazySingleton<ApiConstants>(() => ApiConstants());
  }

  static T get<T extends Object>({String instanceName = ''}) {
   if(instanceName.isNotEmpty){
     return _getIt<T>(instanceName: instanceName);
   }
    return _getIt<T>();
  }

}


