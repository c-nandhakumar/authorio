import 'package:authorio/domain/entities/author_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author_model.g.dart';

@JsonSerializable()
class AuthorModel {
  final int id;
  final String content;
  final String updated;
  final AuthorDetail author;

  AuthorModel({required this.id, required this.content, required this.updated, required this.author});

  factory AuthorModel.fromJson(Map<String, dynamic> json) => _$AuthorModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);

  AuthorEntity toEntity({bool isFavorite = false}) {
    return AuthorEntity(
      id: id,
      name: author.name,
      imageUrl: author.photoUrl,
      content: content,
      updated: DateTime.parse(updated),
      isFavorite: isFavorite,
    );
  }
}

@JsonSerializable()
class AuthorDetail {
  final String name;
  final String photoUrl;

  AuthorDetail({required this.name, required this.photoUrl});

  factory AuthorDetail.fromJson(Map<String, dynamic> json) => _$AuthorDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorDetailToJson(this);
}