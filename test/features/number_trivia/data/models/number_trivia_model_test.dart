import 'dart:convert';

import 'package:clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_names.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture(FixtureNames.trivia));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'should return a valid model when the JSON number is regarded as a double',
      () {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture(FixtureNames.triviaDouble));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing proper data',
      () {
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = <String, dynamic>{
          "text": "Test Text",
          "number": 1,
        };
        expect(
          result,
          expectedMap,
        );
      },
    );
  });
}
