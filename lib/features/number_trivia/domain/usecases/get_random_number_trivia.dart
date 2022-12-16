// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:clean_arch_tdd/core/error/failures.dart';
import 'package:clean_arch_tdd/core/use_cases/use_case.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  const GetRandomNumberTrivia(
    this.repository,
  );

  final NumberTriviaRepository repository;

  @override
  Future<Either<Failure, NumberTrivia>> call(
    NoParams params,
  ) async {
    return await repository.getRandomNumberTrivia();
  }
}
