// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'md_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MDResponse _$MDResponseFromJson(Map<String, dynamic> json) => MDResponse()
  ..status = json['Result'] as String
  ..message = json['Error'] as String
  ..data = json['Data'] as String?
  ..fileID = json['FileId'] as String?
  ..fileName = json['SavedFileName'] as String?
  ..file64 = json['FileData'] as String?
  ..fileExtension = json['FileExt'] as String?;

