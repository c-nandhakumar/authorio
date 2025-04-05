import 'package:authorio/core/failure.dart';
import 'package:authorio/core/utils/log.dart';
import 'package:authorio/core/utils/pair.dart';
import 'package:authorio/core/utils/result.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/author_entity.dart';
import '../../domain/repositories/author_repository.dart';

class AuthorProvider extends ChangeNotifier {
  final AuthorRepository repository;

  List<AuthorEntity> authors = [];
  bool isLoading = false;
  String? _errorMessage;
  String? _nextPageToken;
  bool hasMore = true;
  String? get errorMessage => _errorMessage;

  AuthorProvider({required this.repository});

  Future<void> fetchInitialAuthors() async {
    _nextPageToken = null;
    authors.clear();
    hasMore = true;
    await _fetchAuthors();
  }

  Future<void> fetchMoreAuthors() async {
    if (isLoading || !hasMore) return;
    await _fetchAuthors();
  }

  Future<void> _fetchAuthors() async {
    isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final result = await repository.fetchAuthors(pageToken: _nextPageToken);

    switch (result) {
      case Success<Pair<String?, List<AuthorEntity>>>():
        authors.addAll(result.data.second);
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
    final index = authors.indexWhere((a) => a.id == authorId);
    if (index != -1) {
      authors[index] = authors[index].copyWith(
        isFavorite: !authors[index].isFavorite,
      );
      notifyListeners();
    }
  }

  void deleteAuthor(int authorId) {
    authors.removeWhere((a) => a.id == authorId);
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
