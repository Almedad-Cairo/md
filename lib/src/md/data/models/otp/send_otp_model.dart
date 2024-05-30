import 'dart:convert';

import '../../../../../md_framework.dart';

class SendOtpModel {
  final String functionName, procedureName, to, dataToken;
  final List<dynamic> parametersValues;
  final OtpType otpType;

  SendOtpModel(
      {required this.functionName,
      required this.procedureName,
      required this.parametersValues,
      required this.to,
      required this.otpType,
      required this.dataToken});

  toMap() async {
    String data = await encrypt(
        str: jsonEncode({
      'FunctionName': functionName,
      'ProcedureName': procedureName,
      'ParametersValue': parametersValues.join('#'),
      'AuthType': otpType.index==0?"Email":"Sms",
      'SendTo': to,
      'DataToken': dataToken,
    }));
    return data;
  }
}
