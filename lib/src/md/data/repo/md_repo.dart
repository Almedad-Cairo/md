import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../md.dart';
import '../../../api_constants.dart';
import '../../../network/api_service.dart';
import '../../../network/dio_factory.dart';
import '../models/do_multitransction_model.dart';
import '../models/do_transction_model.dart';
import '../models/download_file_model.dart';
import '../models/execute_procedure_model.dart';
import '../models/md_request_model.dart';
import '../models/upload_flie_model.dart';

class MDRepo {
  final ApiService _apiService;

  MDRepo.a(this._apiService);
  factory MDRepo() {
    return MD<MDRepo>();
  }

  executeProcedure(
      {required String procedureName,
      String? dataToken,
      List<dynamic> columnValues = const []}) async {
    try {
      String data = await ExecuteProcedureModel(
        procedureName: procedureName,
        dataToken: dataToken ?? MD<ApiConstants>().dataToken,
        columnValues: columnValues,
      ).toMap();
      MDRequest model = MDRequest(
        data: data,
      );

      MDResponse resEncrypted = await _apiService.executeProcedure(model);
      MDResponse res = await resEncrypted.decryptData();
      return res;
    } catch (e) {
      rethrow;
    }
  }

  doTransaction(
      {required String tableName,
      String? dataToken,
      required List<dynamic> columnValues,
      required WantedAction action,
      List<String> columnsNames = const []}) async {
    try {
      var data = await DoTransactionModel(
        tableName: tableName,
        dataToken: dataToken ?? MD<ApiConstants>().dataToken,
        columnValues: columnValues,
        columnsNames: columnsNames,
        action: action,
      ).toMap();
      debugPrint('data: $data');
      MDRequest model = MDRequest(
        data: data.toString(),
      );
      MDResponse resEncrypted = await _apiService.doTransaction(model);
      MDResponse res = await resEncrypted.decryptData();

      debugPrint('res: ${res.status}');

      return res;
    } catch (e) {
      rethrow;
    }
  }

  doMultiTransaction(
      {required List<String> tableNames,
      required dataToken,
      required List<List<dynamic>> columnValues,
      required WantedAction action}) async {
    try {
      var data = await DoMultiTransactionModel(
        tableNames: tableNames,
        dataToken: dataToken,
        columnsValues: columnValues,
        action: action,
      ).toMap();
      MDRequest model = MDRequest(
        data: data.toString(),
      );
      MDResponse resEncrypted = await _apiService.doMultiTransaction(model);
      MDResponse res = await resEncrypted.decryptData();
      return res;
    } catch (e) {
      rethrow;
    }
  }

  uploadFile(
      {required WantedAction wantedAction,
      required var image,
      String mainID = "0",
      String subID = "0",
      String detailID = "0",
      required String fileType,
      String fileID = "",
      String description = "",
      String name = "",
      String? dataToken}) async {
    try {
      final bytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );
      final imageBase64 = await compute(encodeImage, bytes);
      var data = await UploadFileModel(
        wantedAction: wantedAction,
        mainID: mainID,
        subID: subID,
        detailID: detailID,
        fileType: fileType,
        fileID: fileID,
        description: description,
        name: name,
      ).toMap();
      MDRequest model = MDRequest(
        data: data.toString(),
        file: imageBase64,
      );
      MDResponse resEncrypted = await _apiService.uploadFile(model);
      MDResponse res = await resEncrypted.decryptData();
      return res;
    } catch (e) {
      rethrow;
    }
  }

  downloadFile({required String fileId, String? dataToken}) async {
    try {
      var data = await DownloadFileModel(
        fileId: fileId,
        dataToken: dataToken ?? MD<ApiConstants>().dataToken,
      ).toMap();
      MDRequest model = MDRequest(
        data: data.toString(),
      );
      MDResponse resEncrypted = await _apiService.downloadFile(model);
      MDResponse res = await resEncrypted.decryptData();

      Directory? dir = await getDownloadsDirectory();
      Directory dir2 = Directory("${dir!.path}/Media");
      var path = dir2.path;
      if (!dir2.existsSync()) {
        dir2.createSync();
      }
      debugPrint('path: $path');
      File file = File("$path/$fileId.${res.fileExtension}");

      // writes with base64 decoding
      //  var bytes =
      //  base64Decode(res.file64!.replaceAll(RegExp(r'\s+'), ''));
      file.writeAsBytesSync(
          base64Decode(res.file64!.replaceAll(RegExp(r'\s+'), '')));
      return file;
    } catch (e) {
      debugPrint('e: $e');
      return false;
    }
  }

  pushNotification(
      {required String title,
      required String body,
      required String token,
      required Map<String, dynamic> dataa}) async {
    try {
      ApiService apiService = ApiService(DioFactory.getDio(),
          baseUrl: ApiConstants.sendNotificationUrl);

      var data = {
        "notification": {
          "title": title,
          "body": body,
        },
        "data": dataa,
        "to": token,
      };
      var res = await apiService.sendNotification(
          data, 'key=${ApiConstants.fcmServerKey}', 'application/json');
      return res;
    } catch (e) {
      rethrow;
    }
  }
}

encodeImage(var bytes) {
  final imageBase64 = base64Encode(bytes);
  return imageBase64;
}
