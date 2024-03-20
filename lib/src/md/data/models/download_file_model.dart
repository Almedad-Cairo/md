import 'dart:convert';

import '../../../../md.dart';
import '../../../api_constants.dart';
import '../../encryption.dart';

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
