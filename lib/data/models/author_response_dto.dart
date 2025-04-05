import 'package:json_annotation/json_annotation.dart';
import 'author_dto.dart';

part 'author_response_dto.g.dart';

@JsonSerializable()
class AuthorResponseDto {
  final int count;
  final List<AuthorDto> messages;
  final String? pageToken;

  AuthorResponseDto({
    required this.count,
    required this.messages,
    this.pageToken,
  });

  factory AuthorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorResponseDtoToJson(this);
}
