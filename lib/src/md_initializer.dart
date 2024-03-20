import 'package:md/src/api_constants.dart';
import 'package:md/src/get_it_initializer.dart';

class MDInitializer {
  static void initialize(
      {required String apiToken,
      required String dataToken,
      required String encryptKey}) {
    GetItInitializer.init();
    GetItInitializer.get<ApiConstants>().initialize(
        apiToken: apiToken, dataToken: dataToken, encryptKey: encryptKey);
  }
}
