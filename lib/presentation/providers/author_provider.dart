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
  String? get errorMessage => _errorMessage;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  List<AuthorEntity> get authors => _isSearching ? _searchResults : _authors;

  AuthorProvider({required this.repository});

  Future<void> fetchInitialAuthors() async {
    _nextPageToken = null;
    _authors.clear();
    hasMore = true;
    await _fetchAuthors();
  }

  Future<void> fetchMoreAuthors() async {
    if (isLoading || !hasMore || _isSearching) return;
    await _fetchAuthors();
  }

  Future<void> _fetchAuthors() async {
    isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final result = await repository.fetchAuthors(pageToken: _nextPageToken);

    switch (result) {
      case Success<Pair<String?, List<AuthorEntity>>>():
        final newAuthors = result.data.second;
        _authors.addAll(newAuthors);
        _nextPageToken = result.data.first;
        hasMore = _nextPageToken != null;

      case Failure(:final failureType):
        Log.i("Erorr : ${failureType.message}");
        _errorMessage = _mapFailureToMessage(failureType);
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(int authorId) {
    final index = _authors.indexWhere((a) => a.id == authorId);
    if (_isSearching) {
      for (var author in _searchResults) {
        if (author.id == authorId) {
          author.isFavorite = !author.isFavorite;
          break;
        }
      }
      notifyListeners();
    }

    if (index != -1) {
      repository.toggleFavorite(
        authorId.toString(),
        !_authors[index].isFavorite,
      );
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
      case UnknownFailure():
        return "An unexpected error occurred.";
    }
    return "An unexpected error occurred.";
  }
}
