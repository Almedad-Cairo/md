import 'package:json_annotation/json_annotation.dart';

import '../../encryption.dart';

part 'md_response_model.g.dart';

@JsonSerializable()
class MDResponse {
  @JsonKey(name: 'Result')
  late String status;
  @JsonKey(name: 'Error')
  late String message;
  @JsonKey(name: 'Data')
  String? data;
  @JsonKey(name: 'FileId')
  String? fileID;
  @JsonKey(name: 'SavedFileName')
  String? fileName;
  @JsonKey(name: 'FileData')
  String? file64;
  @JsonKey(name: 'FileExt')
  String? fileExtension;

  MDResponse();

  factory MDResponse.fromJson(Map<String, dynamic> json) =>
      _$MDResponseFromJson(json);

  Future<MDResponse> decryptData() async {
    status = await decrypt(str: status);
    message = await decrypt(str: message);
    data = (data != '' && data != null)
        ? await decrypt(str: data!.replaceAll("\r\n", ""))
        : '';
    fileExtension = (fileExtension != '' && fileExtension != null)
        ? await decrypt(str: fileExtension!)
        : '';
    fileName = (fileName != '' && fileName != null)
        ? await decrypt(str: fileName!)
        : '';
    fileID =
        (fileID != '' && fileID != null) ? await decrypt(str: fileID!) : '';
    return this;
  }
}
