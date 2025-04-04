class AuthorEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String content;
  final DateTime updated;
  bool isFavorite;

  AuthorEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.content,
    required this.updated,
    this.isFavorite = false,
  });

  AuthorEntity copyWith({bool? isFavorite}) {
    return AuthorEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      content: content,
      updated: updated,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
