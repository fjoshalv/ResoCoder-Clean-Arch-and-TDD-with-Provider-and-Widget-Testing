// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_arch_tdd/core/error/failures.dart';
import 'package:clean_arch_tdd/core/use_cases/use_case.dart';
import 'package:clean_arch_tdd/core/values/app_strings.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:clean_arch_tdd/core/utils/input_converter.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaProvider with ChangeNotifier {
  NumberTriviaProvider({
    required GetConcreteNumberTrivia getConcreteNumberTrivia,
    required GetRandomNumberTrivia getRandomNumberTrivia,
    required InputConverter inputConverter,
  })  : _getConcreteNumberTrivia = getConcreteNumberTrivia,
        _getRandomNumberTrivia = getRandomNumberTrivia,
        _inputConverter = inputConverter;

  // Dependencies
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  final GetRandomNumberTrivia _getRandomNumberTrivia;
  final InputConverter _inputConverter;

  // State variables
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;
  NumberTrivia? currentTrivia;

  // State functions
  Future<void> getTriviaForConcreteNumber(String numberText) async {
    var result = _inputConverter.stringToUnsignedInteger(numberText);
    result.fold(
      (failure) {
        hasError = true;
        errorMessage = AppStrings.invalidInputMessage;
      },
      (parsedNumber) async {
        isLoading = true;
        notifyListeners();
        final getTriviaResult = await _getConcreteNumberTrivia(
          Params(
            number: parsedNumber,
          ),
        );
        isLoading = false;
        _eitherTriviaOrFailure(getTriviaResult);
        notifyListeners();
      },
    );
  }

  Future<void> getTriviaForRandomNumber() async {
    isLoading = true;
    notifyListeners();
    final getTriviaResult = await _getRandomNumberTrivia(
      NoParams(),
    );
    isLoading = false;
    _eitherTriviaOrFailure(getTriviaResult);
    notifyListeners();
  }

  void _eitherTriviaOrFailure(Either<Failure, NumberTrivia> getTriviaResult) {
    getTriviaResult.fold(
      (failure) {
        errorMessage = _mapFailureToMessage(failure);
        hasError = true;
      },
      (trivia) {
        currentTrivia = trivia;
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailureMessage;
      case CacheFailure:
        return AppStrings.cacheFailureMessage;
      default:
        return AppStrings.unexpectedErrorMessage;
    }
  }
}
