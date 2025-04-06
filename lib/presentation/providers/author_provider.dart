import 'package:authorio/core/failure.dart';
import 'package:authorio/core/utils/log.dart';
import 'package:authorio/core/utils/pair.dart';
import 'package:authorio/core/utils/result.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/author_entity.dart';
import '../../domain/repositories/author_repository.dart';

class AuthorProvider extends ChangeNotifier {
  final AuthorRepository repository;
  List<AuthorEntity> _searchResults = [];
  final List<AuthorEntity> _authors = [];

  bool isLoading = false;
  String? _errorMessage;
  String? _nextPageToken;
  bool hasMore = true;
  bool _isError = false;
  String? get errorMessage => _errorMessage;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  bool get isError => _isError;
  List<AuthorEntity> get authors => _isSearching ? _searchResults : _authors;
  List<AuthorEntity> get getFullAuthorList => _authors;
  AuthorProvider({required this.repository});

  Future<void> fetchInitialAuthors() async {
    _nextPageToken = null;
    _authors.clear();
    hasMore = true;
    await _fetchAuthors();
  }

  Future<int> fetchMoreAuthors() async {
    if (isLoading || !hasMore || _isSearching) return 0;
    int newItemsLength = await _fetchAuthors();
    return newItemsLength;
  }

  Future<int> _fetchAuthors() async {
    isLoading = true;
    _isError = false;
    notifyListeners();
    _errorMessage = null;

    final result = await repository.fetchAuthors(pageToken: _nextPageToken);
    isLoading = false;
    switch (result) {
      case Success<Pair<String?, List<AuthorEntity>>>():
        final newAuthors = result.data.second;
        _authors.addAll(newAuthors);
        _nextPageToken = result.data.first;
        hasMore = _nextPageToken != null;
        notifyListeners();
        return newAuthors.length;

      case Failure(:final failureType):
        Log.i("Error : ${failureType.message}");
        _isError = true;
        _errorMessage = _mapFailureToMessage(failureType);
        notifyListeners();
        return 0;
    }
  }

  void toggleFavorite(int authorId) {
    final index = _authors.indexWhere((a) => a.id == authorId);
    Log.d("isFavorite(before) : ${_authors[index].isFavorite}");
    if (_isSearching) {
      for (var author in _searchResults) {
        if (author.id == authorId) {
          author.isFavorite = !author.isFavorite;
          break;
        }
      }
      repository.toggleFavorite(
        authorId.toString(),
        !_authors[index].isFavorite,
      );
      notifyListeners();
      return;
    }

    Log.d("Toggle Favorite : $index");
    if (index != -1) {
      repository.toggleFavorite(
        authorId.toString(),
        !_authors[index].isFavorite,
      );
      Log.d("isFavorite : ${_authors[index].isFavorite}");
      _authors[index] = _authors[index].copyWith(
        isFavorite: !_authors[index].isFavorite,
      );
      notifyListeners();
    }
  }

  void search(String query) {
    _isSearching = query.isNotEmpty;
    if (_isSearching) {
      final lowerQuery = query.toLowerCase();
      _searchResults =
          _authors
              .where((author) => author.name.toLowerCase().contains(lowerQuery))
              .toList();
    } else {
      _searchResults.clear();
    }
    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _searchResults.clear();
    notifyListeners();
  }

  void deleteAuthor(int authorId) {
    _authors.removeWhere((a) => a.id == authorId);
    if (_isSearching) {
      _searchResults.removeWhere((a) => a.id == authorId);
    }

    //Keeping track of deleted authors in local (since there is no API to update)
    repository.deleteAuthor(authorId.toString());

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _mapFailureToMessage(FailureType failure) {
    switch (failure) {
      case NetworkFailure():
        return "Please check your internet connection.";
      case ParsingFailure():
        return "Something went wrong while loading data.";
      case TimeoutFailure():
        return "The server took too long to respond. Try again later.";
      case UnknownFailure():
        return "An unexpected error occurred.";
    }
    return "An unexpected error occurred.";
  }
}
