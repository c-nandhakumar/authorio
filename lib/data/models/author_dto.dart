import 'package:authorio/domain/entities/author_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author_dto.g.dart';

@JsonSerializable()
class AuthorDto {
  final int id;
  final AuthorInfoDto author;
  final String updated;
  final String content;

  AuthorDto({
    required this.id,
    required this.author,
    required this.updated,
    required this.content,
  });

  factory AuthorDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorDtoToJson(this);

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
class AuthorInfoDto {
  final String name;
  final String photoUrl;

  AuthorInfoDto({required this.name, required this.photoUrl});

  factory AuthorInfoDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorInfoDtoToJson(this);
}
