import 'dart:convert';


import '../../../../md_framework.dart';
import '../../../api_constants.dart';
import '../../encryption.dart';

class UploadFileModel {
  late WantedAction wantedAction;

  late String mainID, subID, detailID, fileType, fileID, description, name;

  UploadFileModel({
    required this.wantedAction,
    this.mainID = "0",
    this.subID = "0",
    this.detailID = "0",
    required this.fileType,
    this.fileID = "",
    this.description = "",
    this.name = "",
  });

  toMap() async {
    String action;
    switch (wantedAction) {
      case WantedAction.insert:
        action = 'Add';
      case WantedAction.update:
        action = 'Edit';
      case WantedAction.delete:
        action = 'Delete';
      default:
        action = 'Add';
    }
    String data = await encrypt(
        str: jsonEncode({
      'MainId': mainID,
      'SubId': subID,
      'DetailId': detailID,
      'FileType': fileType,
      'FileId': fileID,
      'Description': description,
      'Name': name,
      'ActionType': action,
      'DataToken': MD<ApiConstants>().dataToken,
    }));
    return data;
  }
}
