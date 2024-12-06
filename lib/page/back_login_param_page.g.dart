// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'back_login_param_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParamResult _$ParamResultFromJson(Map<String, dynamic> json) => ParamResult(
      userId: json['userId'] as String?,
      secretKey: json['secretKey'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      signature: json['signature'] as String?,
    );

Map<String, dynamic> _$ParamResultToJson(ParamResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'secretKey': instance.secretKey,
      'timestamp': instance.timestamp,
      'signature': instance.signature,
    };
