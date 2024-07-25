import 'dart:convert';

import '../../../helper/encryption.dart';



class ExecuteProcedureModel {
  late final String procedureName, dataToken, offset,fetch;
  late  List<dynamic> columnValues;

  ExecuteProcedureModel({
    required this.procedureName,
    required this.dataToken,
    required this.offset,
    required this.fetch,
    required this.columnValues,
  });

  toMap()async {
    columnValues = columnValues.map((e) => e.toString().replaceAll("#", "")).toList();
    return await  encrypt(
      str: jsonEncode({
        'ProcedureName': procedureName,
        'ParametersValues': columnValues.join('#'),
        'DataToken': dataToken,
        'Offset': offset,
        'Fetch': fetch,
      }),
    );
  }
}
