import 'dart:async';

import 'package:authorio/data/datasources/api_client.dart';
import 'package:authorio/data/models/author_response_dto.dart';

class AuthorRemoteDataSource {
  final ApiClient apiClient;

  AuthorRemoteDataSource({required this.apiClient});

  Future<AuthorResponseDto> fetchAuthors({String? pageToken}) async {
    final data = await apiClient
        .get(endpoint: "/messages", queryParams: {"pageToken": pageToken ?? ""})
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException(
              'The connection has timed out, please try again.',
            );
          },
        );
    ;

    return AuthorResponseDto.fromJson(data);
  }
}
