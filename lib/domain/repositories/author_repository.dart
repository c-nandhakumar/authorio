import 'package:authorio/core/utils/types.dart';
import 'package:authorio/domain/entities/author_entity.dart';

abstract class AuthorRepository {
  Future<AuthorPageResult> fetchAuthors({String? pageToken});
  Future<void> deleteAuthor(String id);
  Future<void> toggleFavorite(String id, bool isFavorite);
  Future<List<AuthorEntity>> searchAuthors(String query);
}
