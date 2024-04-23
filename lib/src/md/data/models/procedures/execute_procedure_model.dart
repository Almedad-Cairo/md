import 'dart:convert';

import '../../../helper/encryption.dart';



class ExecuteProcedureModel {
  late final String procedureName, dataToken;
  late final List<dynamic> columnValues;

  ExecuteProcedureModel({
    required this.procedureName,
    required this.dataToken,
    required this.columnValues,
  });

  toMap()async {
    return await  encrypt(
      str: jsonEncode({
        'ProcedureName': procedureName,
        'ParametersValues': columnValues.join('#'),
        'DataToken': dataToken,
      }),
    );
  }
}
