import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../../helper/encryption.dart';

part 'md_response_model.g.dart';

@JsonSerializable()
class MDResponse {
  @JsonKey(name: 'Result')
  late String status;
  @JsonKey(name: 'Error')
  late String message;
  @JsonKey(name: 'Data')
  dynamic data;
  @JsonKey(name: 'FileId')
  String? fileID;
  @JsonKey(name: 'SavedFileName')
  String? fileName;
  @JsonKey(name: 'FileData')
  String? file64;
  @JsonKey(name: 'FileExt')
  String? fileExtension;
  @JsonKey(name: 'TransToken')
  String? otpToken;
  String? ServerTime, newID;
  String? outParameters;
  String? totalRowsCount;


  String? devError;
  String? arError;

  MDResponse();

  MDResponse.a(
      {required this.status,
      required this.message,
      this.data,
      this.fileID,
      this.fileName,
      this.file64,
      this.devError,
      this.arError,
      this.fileExtension});

  factory MDResponse.fromJson(Map<String, dynamic> json) =>
      _$MDResponseFromJson(json);

  Future<MDResponse> decryptData() async {
    status = (await decrypt(str: status)).toString();
    message = await decrypt(str: message);
    if (data != '' && data != null) {
      data = await decrypt(str: data);
      try {
        var data0 = jsonDecode(data);
        totalRowsCount = data0['TotalRowsCount'];
        outParameters = data0['OutParameters'];
      } catch (e) {
        data = data;
      }
    }
    fileExtension = (fileExtension != '' && fileExtension != null)
        ? await decrypt(str: fileExtension!)
        : '';
    fileName = (fileName != '' && fileName != null)
        ? await decrypt(str: fileName!)
        : '';
    fileID =
        (fileID != '' && fileID != null) ? await decrypt(str: fileID!) : '';
    ServerTime = (ServerTime != '' && ServerTime != null)
        ? await decrypt(str: ServerTime!)
        : '';
    newID = (newID != '' && newID != null) ? await decrypt(str: newID!) : '';

    return this;
  }
}
