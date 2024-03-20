import '../../../../md.dart';
import '../../../api_constants.dart';

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
