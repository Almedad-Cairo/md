import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../helper/encryption.dart';
import '../enums/enums.dart';

class DoMultiTransactionModel {
  late final String dataToken;
  late final List<List<dynamic>> columnsValues;
  late final List<String> tableNames;

  late final WantedAction action;

  DoMultiTransactionModel({
    required this.tableNames,
    required this.dataToken,
    required this.columnsValues,
    required this.action,
  });

  toMap() async {
    var d = columnsValues.map((e) => e.join('#')).toList();
    String columnValues = d.join('^');
    debugPrint('columnValues: $columnValues');

    String data = await encrypt(
        str: jsonEncode({
      'MultiTableName': tableNames.join('^'),
      'MultiColumnsValues': columnValues,
      'WantedAction': action.index,
      "PointId": "0",
      'DataToken': dataToken,
    }));
    return data;
  }
}
