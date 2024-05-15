import '../../../../../md_framework.dart';
import '../../../../api_constants.dart';

class MDRequest {
  late String data;
  late String file;
  String? apiToken;

  MDRequest(
      {required this.data,
      this.file = "",
        this.apiToken

      });

  toJson() {
    return {
      "ApiToken": apiToken??MD<ApiConstants>().apiToken,
      "Data": data,
      "encode_plc1": file,

    };
  }
}
