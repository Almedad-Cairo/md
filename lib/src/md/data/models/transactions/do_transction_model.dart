import 'dart:convert';

import 'package:md_framework/src/md/data/models/enums/enums.dart';

import '../../../helper/encryption.dart';

class DoTransactionModel {
  late final String tableName, dataToken;
  late final List<dynamic> columnValues;
  late final List<String> columnsNames;
  late final WantedAction action;
  late bool sendNotification;
  late String notificationProcedure;
  late String notificationParameters;

  DoTransactionModel(
      {required this.tableName,
      required this.dataToken,
      required this.columnValues,
      required this.action,
      this.columnsNames = const [],
      this.sendNotification = false,
      this.notificationProcedure = "",
      this.notificationParameters = ""});

  toMap() async {
    String data = await encrypt(
        str: jsonEncode({
      'TableName': tableName,
      'ColumnsValues': columnValues.join('#'),
      "ColumnsNames": columnsNames.join('#'),
      'WantedAction': action.index,
      "PointId": "0",
      'DataToken': dataToken,
      "SendNotification": sendNotification ? "T" : "F",
      "NotificationProcedure": notificationProcedure,
      "NotificationPranameters": notificationParameters,
    }));
    return data;
  }
}
