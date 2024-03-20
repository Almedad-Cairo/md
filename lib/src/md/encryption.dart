import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as m;

import '../api_constants.dart';


Future<String> encrypt(
    {required String str, String? key }) async {
  key = key ?? ApiConstants.encryptKey;
  try {
    m.debugPrint("str: $str");
    m.debugPrint("key: $key");
    List<int> key0 = [];
    key0.addAll(ascii.encode(key).toList());
    List<int> iv = [];
    iv.addAll(ascii.encode(key.substring(0, 16)).toList());
    if (key0.length < 32) {
      var l = 32 - key0.length;
      for (int i = 0; i < l; i++) {
        key0.add(0);
      }
    }

    if (iv.length < 16) {
      var l = 16 - iv.length;
      for (int i = 0; i < l; i++) {
        iv.add(0);
      }
    }

    final encrypter = Encrypter(
      AES(
        Key(Uint8List.fromList(key0)),
        mode: AESMode.cbc,
        padding: "PKCS7",
      ),
    );
    final encrypted = encrypter.encrypt(str, iv: IV(Uint8List.fromList(iv)));
    m.debugPrint("encrypted: ${encrypted.base64}");
    return encrypted.base64;
  } catch (e) {
    m.debugPrint("error: $e");
    return "error $e";
  }

  // }catch
}

decrypt({String? key, required String str}) async{
  key = key ?? ApiConstants.encryptKey;
  try {
    m.debugPrint("str: $str");
    m.debugPrint("key: $key");
    List<int> key0 = [];
    key0.addAll(ascii.encode(key).toList());
    List<int> iv = [];
    iv.addAll(ascii.encode(key.substring(0, 16)).toList());

    if (key0.length < 32) {
      var l = 32 - key0.length;
      for (int i = 0; i < l; i++) {
        key0.add(0);
      }
    }

    if (iv.length < 16) {
      var l = 16 - iv.length;
      for (int i = 0; i < l; i++) {
        iv.add(0);
      }
    }
    // Decrypted using ASE256CBC with the privatekey

    final encrypter = Encrypter(
      AES(
        Key(Uint8List.fromList(key0)),
        mode: AESMode.cbc,
        padding: "PKCS7",
      ),
    );
    final decrypted = encrypter.decrypt(Encrypted.from64(str),
        iv: IV(Uint8List.fromList(iv)));
    m.debugPrint("decrypted: $decrypted");
    return decrypted;
  } catch (e) {
    m.debugPrint("error: $e");
    return "error $e";
  }
}
