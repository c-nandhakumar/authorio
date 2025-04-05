import 'package:authorio/data/datasources/api_client.dart';
import 'package:authorio/data/models/author_response_dto.dart';

class AuthorRemoteDataSource {
  final ApiClient apiClient;

  AuthorRemoteDataSource({required this.apiClient});

  Future<AuthorResponseDto> fetchAuthors({String? pageToken}) async {
    final data = await apiClient.get(
      endpoint: "/messages",
      queryParams: {"pageToken": pageToken ?? ""},
    );

    return AuthorResponseDto.fromJson(data);
  }
}
