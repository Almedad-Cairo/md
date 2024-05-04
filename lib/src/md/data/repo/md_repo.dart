import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:md_framework/src/md/data/models/notifications/md_notification.dart';
import 'package:md_framework/src/md/data/models/otp/send_otp_model.dart';
import 'package:md_framework/src/network/api_error_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../md_framework.dart';
import '../../../api_constants.dart';
import '../../../network/api_service.dart';
import '../models/transactions/do_multitransction_model.dart';
import '../models/transactions/do_transction_model.dart';
import '../models/files/download_file_model.dart';
import '../models/procedures/execute_procedure_model.dart';
import '../models/request/md_request_model.dart';
import '../models/files/upload_flie_model.dart';
import '../models/otp/verify_otp_model.dart';

class MDRepo {
  final ApiService _apiService;

  MDRepo.a(this._apiService);

  factory MDRepo() {
    GetIt getIt = GetIt.instance;
    return getIt.get<MDRepo>(instanceName: 'md_repo');
  }

  executeProcedure(
      {required String procedureName,
      String? dataToken,
      List<dynamic> columnValues = const []}) async {
    try {
      return await executeProcedure2(
          procedureName: procedureName,
          dataToken: dataToken,
          columnValues: columnValues);
    } on DioException catch (e) {
      return ApiErrorHandler.getError(e);
    } catch (e) {
      rethrow;
    }
  }

// try 3 times
  executeProcedure2(
      {required String procedureName,
      String? dataToken,
      int tryCount = 0,
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
    } on DioException catch (e) {
      MDResponse res = ApiErrorHandler.getError(e);
      debugPrint('tryCount: $tryCount in procedure $procedureName');
      if (tryCount < 3 && (res.status == '408' || res.status == '500')) {
        tryCount++;
        return executeProcedure2(
            procedureName: procedureName,
            dataToken: dataToken,
            tryCount: tryCount,
            columnValues: columnValues);
      }
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
      MDNotification? notification,
      List<String> columnsNames = const []}) async {
    try {
      var data = await DoTransactionModel(
        tableName: tableName,
        dataToken: dataToken ?? MD<ApiConstants>().dataToken,
        columnValues: columnValues,
        columnsNames: columnsNames,
        action: action,
        sendNotification: notification != null,
        notificationProcedure: notification?.procedureName ?? "",
        notificationParameters: mapNotification(notification),
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
    } on DioException catch (e) {
      return ApiErrorHandler.getError(e);
    } catch (e) {
      rethrow;
    }
  }

  getSerialNumber() async {
    // return await DeviceInfo.getSerial();
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
      final bytes;
      if (fileType == ".png" || fileType == ".jpg" || fileType == ".jpeg") {
        bytes = await FlutterImageCompress.compressWithFile(
          image.path,
          quality: 50,
        );
      } else {
        bytes = await image.readAsBytes();
      }
      debugPrint('bytes: ${bytes == null ? 'null' : 'not null'}');
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
    } on DioException catch (e) {
      return ApiErrorHandler.getError(e);
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
    } on DioException catch (e) {
      return ApiErrorHandler.getError(e);
    } catch (e) {
      debugPrint('e: $e');
      return false;
    }
  }

  // @Deprecated(
  //     'Push notification is Deprecated, use send notification in doTransaction instead')
  // pushNotification(
  //     {required String title,
  //     required String body,
  //     required String token,
  //     required Map<String, dynamic> dataa}) async {
  //   try {
  //     ApiService apiService = ApiService(DioFactory.getDio(),
  //         baseUrl: ApiConstants.sendNotificationUrl);
  //
  //     var data = {
  //       "notification": {
  //         "title": title,
  //         "body": body,
  //       },
  //       "data": dataa,
  //       "to": token,
  //     };
  //     var res = await apiService.sendNotification(
  //         data, 'key=${ApiConstants.fcmServerKey}', 'application/json');
  //     return res;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  sendOtp(
      {required String functionName,
      required String procedureName,
      required List<dynamic> parametersValues,
      required String to,
      required OtpType otpType,
      String? dataToken}) async {
    try {
      var model = await SendOtpModel(
        functionName: functionName,
        procedureName: procedureName,
        parametersValues: parametersValues,
        otpType: otpType,
        to: to,
        dataToken: dataToken ?? MD<ApiConstants>().dataToken,
      ).toMap();
      MDRequest mdRequest = MDRequest(data: model);
      MDResponse resEncrypted = await _apiService.sendOTP(mdRequest);
      MDResponse res = await resEncrypted.decryptData();
      return res;
    } on DioException catch (e) {
      return ApiErrorHandler.getError(e);
    } catch (e) {
      rethrow;
    }
  }

  verifyOtp(
      {required String otpToken,
      required String otp,
      String? dataToken}) async {
    try {
      var model = await VerifyOtpModel(
        otpToken: otpToken,
        otp: otp,
        dataToken: dataToken ?? MD<ApiConstants>().dataToken,
      ).toMap();
      MDRequest mdRequest = MDRequest(data: model);
      MDResponse resEncrypted = await _apiService.verifyOTP(mdRequest);
      MDResponse res = await resEncrypted.decryptData();
      return res;
    } on DioException catch (e) {
      return ApiErrorHandler.getError(e);
    } catch (e) {
      rethrow;
    }
  }
}

encodeImage(var bytes) {
  final imageBase64 = base64Encode(bytes);
  return imageBase64;
}
