import '../../../api_constants.dart';
import '../../../get_it_initializer.dart';

class MDRequest {
  late String data;
  late String file;
  MDRequest({required this.data, this.file = ""});

  toJson() {
    return {
      "ApiToken": MD<ApiConstants>().apiToken,
      "Data": data,
      "encode_plc1": file,
    };
  }
}
