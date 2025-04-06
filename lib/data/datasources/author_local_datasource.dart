import 'package:shared_preferences/shared_preferences.dart';

class AuthorLocalDataSource {
  final SharedPreferences prefs;
  AuthorLocalDataSource({required this.prefs});
  static const String _favoriteKey = 'favorite_authors';
  static const String _deletedAuthorsKey = 'deleted_authors';

  Future<List<String>> getFavoriteAuthors() async {
    return prefs.getStringList(_favoriteKey) ?? [];
  }

  Future<void> toggleFavorite(String id) async {
    final favorites = await getFavoriteAuthors();

    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    await prefs.setStringList(_favoriteKey, favorites);
  }

  Future<List<String>> getDeletedAuthors() async {
    return prefs.getStringList(_deletedAuthorsKey) ?? [];
  }

  Future<void> trackDeletedAuthors(String authorId) async {
    final deletedAuthors = await getDeletedAuthors();
    deletedAuthors.add(authorId);
    await prefs.setStringList(_deletedAuthorsKey, deletedAuthors);
  }
}
