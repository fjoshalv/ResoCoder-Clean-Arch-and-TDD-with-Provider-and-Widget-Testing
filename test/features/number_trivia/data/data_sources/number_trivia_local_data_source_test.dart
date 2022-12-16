import 'dart:convert';

import 'package:clean_arch_tdd/core/error/exceptions.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_names.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(
          fixture(
            FixtureNames.triviaCached,
          ),
        ),
      );
      test(
        'should return NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            fixture(
              FixtureNames.triviaCached,
            ),
          );
          // act
          final result = await dataSource.getLastNumberTrivia();
          // assert
          verify(
            mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY),
          );
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw CacheException when there is not a cached value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          final call = dataSource.getLastNumberTrivia;

          // assert
          expect(call, throwsA(isA<CacheException>()));
        },
      );
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      const tNumberTriviaModel =
          NumberTriviaModel(text: 'Test Trivia', number: 1);
      test(
        'should call SharedPreferences to cache the data',
        () async {
          // arrange
          when(mockSharedPreferences.setString(any, any)).thenAnswer(
            (_) => Future.value(true),
          );
          // act
          dataSource.cacheNumberTrivia(tNumberTriviaModel);
          // assert
          final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
          verify(
            mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA_KEY,
              expectedJsonString,
            ),
          );
        },
      );
    },
  );
}
