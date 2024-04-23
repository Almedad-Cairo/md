import 'dart:convert';

import '../../../../../md_framework.dart';
import '../../../../api_constants.dart';
import '../../../helper/encryption.dart';

class DownloadFileModel {
  late String? fileId, dataToken;

  DownloadFileModel({required this.fileId, this.dataToken});

  toMap() async {
    String data = await encrypt(
        str: jsonEncode({
      'FileId': fileId,
      'DataToken': dataToken ?? MD<ApiConstants>().dataToken,
    }));
    return data;
  }
}
