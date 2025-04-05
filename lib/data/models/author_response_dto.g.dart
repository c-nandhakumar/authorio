// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorResponseDto _$AuthorResponseDtoFromJson(Map<String, dynamic> json) =>
    AuthorResponseDto(
      count: (json['count'] as num).toInt(),
      messages:
          (json['messages'] as List<dynamic>)
              .map((e) => AuthorDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      pageToken: json['pageToken'] as String?,
    );

Map<String, dynamic> _$AuthorResponseDtoToJson(AuthorResponseDto instance) =>
    <String, dynamic>{
      'count': instance.count,
      'messages': instance.messages,
      'pageToken': instance.pageToken,
    };
