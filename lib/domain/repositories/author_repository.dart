import 'package:authorio/domain/entities/author_entity.dart';

abstract class AuthorRepository {
  Future<List<AuthorEntity>> fetchAuthors({String? pageToken});
  Future<void> deleteAuthor(String id);
  Future<void> toggleFavorite(String id, bool isFavorite);
  Future<List<AuthorEntity>> searchAuthors(String query);
}
