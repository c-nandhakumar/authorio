import 'package:shared_preferences/shared_preferences.dart';

class AuthorLocalDataSource {
  static const String _favoriteKey = 'favorite_authors';

  Future<List<String>> getFavoriteAuthors() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteKey) ?? [];
  }

  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteAuthors();

    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    await prefs.setStringList(_favoriteKey, favorites);
  }
}
