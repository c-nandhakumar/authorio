// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) => AuthorModel(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  updated: json['updated'] as String,
  author: AuthorDetail.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthorModelToJson(AuthorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'updated': instance.updated,
      'author': instance.author,
    };

AuthorDetail _$AuthorDetailFromJson(Map<String, dynamic> json) => AuthorDetail(
  name: json['name'] as String,
  photoUrl: json['photoUrl'] as String,
);

Map<String, dynamic> _$AuthorDetailToJson(AuthorDetail instance) =>
    <String, dynamic>{'name': instance.name, 'photoUrl': instance.photoUrl};
