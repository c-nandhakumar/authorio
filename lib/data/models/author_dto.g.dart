// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorDto _$AuthorDtoFromJson(Map<String, dynamic> json) => AuthorDto(
  id: (json['id'] as num).toInt(),
  author: AuthorInfoDto.fromJson(json['author'] as Map<String, dynamic>),
  updated: json['updated'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$AuthorDtoToJson(AuthorDto instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author,
  'updated': instance.updated,
  'content': instance.content,
};

AuthorInfoDto _$AuthorInfoDtoFromJson(Map<String, dynamic> json) =>
    AuthorInfoDto(
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
    );

Map<String, dynamic> _$AuthorInfoDtoToJson(AuthorInfoDto instance) =>
    <String, dynamic>{'name': instance.name, 'photoUrl': instance.photoUrl};
