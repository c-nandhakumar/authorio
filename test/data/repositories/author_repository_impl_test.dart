import 'dart:io';

import 'package:authorio/core/failure.dart';
import 'package:authorio/core/utils/pair.dart';
import 'package:authorio/core/utils/result.dart';
import 'package:authorio/data/models/author_dto.dart';
import 'package:authorio/data/models/author_response_dto.dart';
import 'package:authorio/data/repositories/author_repository_impl.dart';
import 'package:authorio/domain/entities/author_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthorRemoteDataSource mockRemote;
  late MockAuthorLocalDataSource mockLocal;
  late AuthorRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthorRemoteDataSource();
    mockLocal = MockAuthorLocalDataSource();
    repository = AuthorRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('fetchAuthors', () {
    final dto = AuthorDto(
      id: 1,
      author: AuthorInfoDto(name: 'Alice', photoUrl: 'https://example.com'),
      content: 'Hello',
      updated: DateTime.now().toIso8601String(),
    );

    final pageDto = AuthorResponseDto(
      count: 1,
      pageToken: 'next-token',
      messages: [dto],
    );

    test('should return Success when remote and local succeed', () async {
      when(
        mockRemote.fetchAuthors(pageToken: anyNamed('pageToken')),
      ).thenAnswer((_) async => pageDto);
      when(mockLocal.getFavoriteAuthors()).thenAnswer((_) async => ['1']);

      final result = await repository.fetchAuthors();

      expect(result, isA<Success<Pair<String?, List<AuthorEntity>>>>());
      final data = (result as Success).data;
      expect(data.first, 'next-token');
      expect(data.second.first.name, 'Alice');
      expect(data.second.first.isFavorite, true);
    });

    test('should return NetworkFailure on SocketException', () async {
      when(
        mockRemote.fetchAuthors(pageToken: anyNamed('pageToken')),
      ).thenThrow(SocketException("No Internet"));

      final result = await repository.fetchAuthors();

      expect(result, isA<Failure>());
      expect((result as Failure).failureType, isA<NetworkFailure>());
    });

    test('should return ParsingFailure on TypeError', () async {
      when(
        mockRemote.fetchAuthors(pageToken: anyNamed('pageToken')),
      ).thenThrow(TypeError());

      final result = await repository.fetchAuthors();

      expect(result, isA<Failure>());
      expect((result as Failure).failureType, isA<ParsingFailure>());
    });

    test('should return UnknownFailure on any other error', () async {
      when(
        mockRemote.fetchAuthors(pageToken: anyNamed('pageToken')),
      ).thenThrow(Exception("Unexpected"));

      final result = await repository.fetchAuthors();

      expect(result, isA<Failure>());
      expect((result as Failure).failureType, isA<UnknownFailure>());
    });
  });
}
