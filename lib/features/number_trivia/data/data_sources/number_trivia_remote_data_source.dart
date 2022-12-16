// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:clean_arch_tdd/core/error/exceptions.dart';
import 'package:dio/dio.dart';

import 'package:clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  // Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  NumberTriviaRemoteDataSourceImpl({
    required this.client,
    required this.options,
  }) {
    options.headers = {'Content-Type': 'application/json'};
    // Add to test
    options.responseType = ResponseType.plain;
  }

  final Dio client;
  final Options options;

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl(
        'http://numbersapi.com/$number',
      );

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl(
        'http://numbersapi.com/random',
      );

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      url,
      options: options,
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(
        json.decode(response.data),
      );
    } else {
      throw ServerException();
    }
  }
}
