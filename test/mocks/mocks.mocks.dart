// Mocks generated by Mockito 5.4.5 from annotations
// in authorio/test/mocks/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:authorio/data/datasources/api_client.dart' as _i2;
import 'package:authorio/data/datasources/author_local_datasource.dart' as _i6;
import 'package:authorio/data/datasources/author_remote_datasource.dart' as _i4;
import 'package:authorio/data/models/author_response_dto.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeApiClient_0 extends _i1.SmartFake implements _i2.ApiClient {
  _FakeApiClient_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAuthorResponseDto_1 extends _i1.SmartFake
    implements _i3.AuthorResponseDto {
  _FakeAuthorResponseDto_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AuthorRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthorRemoteDataSource extends _i1.Mock
    implements _i4.AuthorRemoteDataSource {
  MockAuthorRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ApiClient get apiClient =>
      (super.noSuchMethod(
            Invocation.getter(#apiClient),
            returnValue: _FakeApiClient_0(this, Invocation.getter(#apiClient)),
          )
          as _i2.ApiClient);

  @override
  _i5.Future<_i3.AuthorResponseDto> fetchAuthors({String? pageToken}) =>
      (super.noSuchMethod(
            Invocation.method(#fetchAuthors, [], {#pageToken: pageToken}),
            returnValue: _i5.Future<_i3.AuthorResponseDto>.value(
              _FakeAuthorResponseDto_1(
                this,
                Invocation.method(#fetchAuthors, [], {#pageToken: pageToken}),
              ),
            ),
          )
          as _i5.Future<_i3.AuthorResponseDto>);
}

/// A class which mocks [AuthorLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthorLocalDataSource extends _i1.Mock
    implements _i6.AuthorLocalDataSource {
  MockAuthorLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<String>> getFavoriteAuthors() =>
      (super.noSuchMethod(
            Invocation.method(#getFavoriteAuthors, []),
            returnValue: _i5.Future<List<String>>.value(<String>[]),
          )
          as _i5.Future<List<String>>);

  @override
  _i5.Future<void> toggleFavorite(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#toggleFavorite, [id]),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);
}
