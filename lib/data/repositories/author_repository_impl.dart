import 'dart:io';

import 'package:authorio/core/failure.dart';
import 'package:authorio/core/utils/pair.dart';
import 'package:authorio/core/utils/result.dart';
import 'package:authorio/core/utils/types.dart';
import 'package:authorio/data/datasources/author_local_datasource.dart';
import 'package:authorio/data/datasources/author_remote_datasource.dart';
import 'package:authorio/domain/entities/author_entity.dart';
import 'package:authorio/domain/repositories/author_repository.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthorRemoteDataSource remoteDataSource;
  final AuthorLocalDataSource localDataSource;

  AuthorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<AuthorPageResult> fetchAuthors({String? pageToken}) async {
    try {
      final response = await remoteDataSource.fetchAuthors(
        pageToken: pageToken,
      );
      final favoriteIds = await localDataSource.getFavoriteAuthors();

      return Success(
        Pair(
          response.pageToken,
          response.messages.map((model) {
            return model.toEntity(
              isFavorite: favoriteIds.contains(model.id.toString()),
            );
          }).toList(),
        ),
      );
    } on TypeError catch (e) {
      return Failure(ParsingFailure("Type mismatch: ${e.toString()}"));
    } on SocketException {
      return Failure(NetworkFailure("No Internet"));
    } catch (_) {
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<List<AuthorEntity>> searchAuthors(String query) {
    // TODO: implement searchAuthors
    throw UnimplementedError();
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await localDataSource.toggleFavorite(id);
  }

  @override
  Future<void> deleteAuthor(String id) {
    // TODO: implement deleteAuthor
    throw UnimplementedError();
  }
}
