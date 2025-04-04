import 'package:authorio/data/datasources/author_local_datasource.dart';
import 'package:authorio/data/datasources/author_remote_datasource.dart';
import 'package:authorio/data/models/author_model.dart';
import 'package:authorio/domain/entities/author_entity.dart';
import 'package:authorio/domain/repositories/author_repository.dart';

class AuthorRepositoryImpl implements AuthorRepository{
  final AuthorRemoteDataSource remoteDataSource;
  final AuthorLocalDataSource localDataSource;

  AuthorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
   @override
  Future<List<AuthorEntity>> fetchAuthors({String? pageToken}) async{
    final List<AuthorModel> models = await remoteDataSource.fetchAuthors(pageToken: pageToken);
    final favoriteIds = await localDataSource.getFavoriteAuthors();

    return models.map((model) {
      return model.toEntity(isFavorite: favoriteIds.contains(model.id.toString()));
    }).toList();
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