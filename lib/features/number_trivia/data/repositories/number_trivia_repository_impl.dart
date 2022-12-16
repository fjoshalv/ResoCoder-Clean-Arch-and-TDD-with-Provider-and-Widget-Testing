// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_arch_tdd/core/error/exceptions.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_arch_tdd/core/error/failures.dart';
import 'package:clean_arch_tdd/core/network/network_info.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _FutureTrivia = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  const NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(remoteDataSource.getRandomNumberTrivia);
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _FutureTrivia dataSourceCall,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await dataSourceCall();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedTrivia = await localDataSource.getLastNumberTrivia();
        return Right(cachedTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
