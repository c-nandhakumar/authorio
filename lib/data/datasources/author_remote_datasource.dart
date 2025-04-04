import 'package:authorio/data/datasources/api_client.dart';

import '../models/author_model.dart';

class AuthorRemoteDataSource {
  final ApiClient apiClient;

  AuthorRemoteDataSource({required this.apiClient});

  Future<List<AuthorModel>> fetchAuthors({String? pageToken}) async {
    final data = await apiClient.get(endpoint: "/messages", queryParams: {"pageToken": pageToken ?? ""});
    final List<dynamic> messages = data['messages'];

    return messages.map((json) => AuthorModel.fromJson(json)).toList();
  }
}
