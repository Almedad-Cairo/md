import 'dart:convert';

import 'package:md_framework/src/md/data/models/wanted_action.dart';

import '../../encryption.dart';

class DoTransactionModel {
  late final String tableName, dataToken;
  late final List<dynamic> columnValues;
  late final List<String> columnsNames;
  late final WantedAction action;

  DoTransactionModel({
    required this.tableName,
    required this.dataToken,
    required this.columnValues,
    required this.action,
    this.columnsNames = const [],
  });

  toMap() async {
    String data = await encrypt(
        str: jsonEncode({
      'TableName': tableName,
      'ColumnsValues': columnValues.join('#'),
      "ColumnsNames": columnsNames.join('#'),
      'WantedAction': action.index,
      "PointId": "0",
      'DataToken': dataToken,
    }));
    return data;
  }
}
