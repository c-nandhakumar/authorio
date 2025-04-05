import 'package:authorio/data/models/author_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthorDto fromJson', () {
    test('should parse valid JSON correctly', () {
      final json = {
        "id": 1,
        "author": {
          "name": "John Doe",
          "photoUrl": "https://example.com/photo.jpg",
        },
        "updated": "2023-12-01T12:00:00Z",
        "content": "Hello world!",
      };

      final result = AuthorDto.fromJson(json);

      expect(result.id, 1);
      expect(result.author.name, "John Doe");
      expect(result.author.photoUrl, "https://example.com/photo.jpg");
      expect(result.content, "Hello world!");
    });

    test('should throw error on invalid/malformed JSON', () {
      final invalidJson = {
        "id": 1,
        // missing "author" field
        "updated": "2023-12-01T12:00:00Z",
        "content": "Oops!",
      };

      expect(() => AuthorDto.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });

    test('should throw error on wrong data type', () {
      final wrongTypeJson = {
        "id": "not an int", // should be int
        "author": {"name": "Test", "photoUrl": "url"},
        "updated": "time",
        "content": "content",
      };

      expect(
        () => AuthorDto.fromJson(wrongTypeJson),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
