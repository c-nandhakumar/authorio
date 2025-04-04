import 'package:authorio/data/datasources/api_client.dart';
import 'package:authorio/data/datasources/author_local_datasource.dart';
import 'package:authorio/data/datasources/author_remote_datasource.dart';
import 'package:authorio/data/repositories/author_repository_impl.dart';
import 'package:authorio/domain/repositories/author_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void initializeDependencies() {
  locator.registerLazySingleton(() => ApiClient(client: http.Client()));

  //DataSources
  locator.registerLazySingleton(
    () => AuthorRemoteDataSource(apiClient: locator<ApiClient>()),
  );
  locator.registerLazySingleton(() => AuthorLocalDataSource());

  //Repository
  locator.registerLazySingleton<AuthorRepository>(
    () => AuthorRepositoryImpl(
      remoteDataSource: locator<AuthorRemoteDataSource>(),
      localDataSource: locator<AuthorLocalDataSource>(),
    ),
  );
}
