import 'package:md_framework/src/api_constants.dart';
import 'package:md_framework/src/get_it_initializer.dart';

class MDInit {
  static void initialize(
      {required String apiToken,
      required String dataToken,
      required String encryptKey}) {
    GetItInitializer.init();
    GetItInitializer.get<ApiConstants>().initialize(
        apiToken: apiToken, dataToken: dataToken, encryptKey: encryptKey);
  }
}

T MD<T extends Object>() => GetItInitializer.get<T>();
