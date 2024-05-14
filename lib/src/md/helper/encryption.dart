import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

import '../../../md_framework.dart';
import '../../api_constants.dart';

Future<String> encrypt({required String str, String? key}) async {
  key = key ?? MD<ApiConstants>().encryptKey;
  try {
    final encrypter = _buildEncrypter(key);
    final encrypted =
        encrypter.encrypt(str, iv: IV(Uint8List.fromList(_buildIV(key))));
    return encrypted.base64;
  } catch (e) {
    throw Exception('Encryption error: $e');
  }
}

Future<String> decrypt({required String str, String? key}) async {
  String encrypted = str.trim().replaceAll(RegExp(r'\s+'), '').replaceAll("\\r", '').replaceAll("\\n", "");
  key = key ?? MD<ApiConstants>().encryptKey;
  try {
    final encrypter = _buildEncrypter(key);
    final decrypted = encrypter.decrypt(Encrypted.from64(encrypted),
        iv: IV(Uint8List.fromList(_buildIV(key))));
    // jsonDecode is used to check if the decrypted string is a valid json
    // if it is not a valid json, it will throw an exception
    // try {
    //   jsonDecode(decrypted);
    // } catch (e) {
    //   return decrypted;
    // }
    return decrypted;
  } catch (e) {
    throw Exception('Decryption error: $e');
  }
}

Encrypter _buildEncrypter(String key) {
  List<int> keyBytes = _buildKey(key);
  return Encrypter(
    AES(
      Key(Uint8List.fromList(keyBytes)),
      mode: AESMode.cbc,
      padding: "PKCS7",
    ),
  );
}

List<int> _buildKey(String key) {
  List<int> keyBytes = ascii.encode(key).toList();
  if (keyBytes.length < 32) {
    keyBytes.addAll(List<int>.filled(32 - keyBytes.length, 0));
  }
  return keyBytes;
}

List<int> _buildIV(String key) {
  List<int> iv = ascii.encode(key).toList();
  if (iv.length < 16) {
    iv.addAll(List<int>.filled(16 - iv.length, 0));
  }
  return iv;
}
