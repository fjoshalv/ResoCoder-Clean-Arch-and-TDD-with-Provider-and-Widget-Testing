// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:clean_arch_tdd/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';

const CACHED_NUMBER_TRIVIA_KEY = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  const NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });
  final SharedPreferences sharedPreferences;

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY);
    if (jsonString != null) {
      return NumberTriviaModel.fromJson(
        json.decode(jsonString),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA_KEY,
      json.encode(
        triviaToCache.toJson(),
      ),
    );
  }
}
