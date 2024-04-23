import 'dart:convert';

import '../../../helper/encryption.dart';

class VerifyOtpModel {
final String otpToken,otp,dataToken;

  VerifyOtpModel({
    required this.otpToken,
    required this.otp,
    required this.dataToken,
  });

  toMap() async {
    String data = await encrypt(
        str: jsonEncode({
      'TransToken': otpToken,
      'VerCode': otp,
      'DataToken': dataToken,
    }));
    return data;
  }

}