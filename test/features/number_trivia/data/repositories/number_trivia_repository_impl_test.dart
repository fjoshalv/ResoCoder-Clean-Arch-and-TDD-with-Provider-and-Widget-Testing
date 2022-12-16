import 'package:clean_arch_tdd/core/error/exceptions.dart';
import 'package:clean_arch_tdd/core/error/failures.dart';
import 'package:clean_arch_tdd/core/network/network_info.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(void Function() body) {
    group(
      'device is online',
      () {
        setUp(
          () {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          },
        );
        body();
      },
    );
  }

  void runTestOffline(void Function() body) {
    group(
      'device is offline',
      () {
        setUp(
          () {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          },
        );
        body();
      },
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      const tNumber = 1;
      const tNumberTriviaModel = NumberTriviaModel(
        text: 'Test Trivia',
        number: tNumber,
      );
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );

      runTestOnline(
        () {
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any),
              ).thenAnswer(
                (_) async => tNumberTriviaModel,
              );
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                  tNumber,
                ),
              );
              expect(
                result,
                equals(Right(tNumberTrivia)),
              );
            },
          );

          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any),
              ).thenAnswer(
                (_) async => tNumberTriviaModel,
              );
              // act
              await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                  tNumber,
                ),
              );
              verify(
                mockNumberTriviaLocalDataSource
                    .cacheNumberTrivia(tNumberTriviaModel),
              );
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any),
              ).thenThrow(
                ServerException(),
              );
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                  tNumber,
                ),
              );
              verifyZeroInteractions(mockNumberTriviaLocalDataSource);
              expect(
                result,
                equals(
                  Left(
                    ServerFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
      runTestOffline(
        () {
          test(
            'should return last locally cache data when the cache data is present',
            () async {
              // arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
              expect(
                result,
                equals(
                  const Right(tNumberTrivia),
                ),
              );
            },
          );

          test(
            'should return CacheFailure when there is no cached data',
            () async {
              // arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
              expect(
                result,
                equals(
                  Left(CacheFailure()),
                ),
              );
            },
          );
        },
      );
    },
  );
  // Random number trivia
  group(
    'getRandomNumberTrivia',
    () {
      const tNumberTriviaModel = NumberTriviaModel(
        text: 'Test Trivia',
        number: 123,
      );
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repository.getRandomNumberTrivia();
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );

      runTestOnline(
        () {
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              ).thenAnswer(
                (_) async => tNumberTriviaModel,
              );
              // act
              final result = await repository.getRandomNumberTrivia();
              // assert
              verify(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              );
              expect(
                result,
                equals(const Right(tNumberTrivia)),
              );
            },
          );

          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              ).thenAnswer(
                (_) async => tNumberTriviaModel,
              );
              // act
              await repository.getRandomNumberTrivia();
              // assert
              verify(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              );
              verify(
                mockNumberTriviaLocalDataSource
                    .cacheNumberTrivia(tNumberTriviaModel),
              );
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              ).thenThrow(
                ServerException(),
              );
              // act
              final result = await repository.getRandomNumberTrivia();
              // assert
              verify(
                mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
              );
              verifyZeroInteractions(mockNumberTriviaLocalDataSource);
              expect(
                result,
                equals(
                  Left(
                    ServerFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
      runTestOffline(
        () {
          test(
            'should return last locally cache data when the cache data is present',
            () async {
              // arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await repository.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
              expect(
                result,
                equals(
                  const Right(tNumberTrivia),
                ),
              );
            },
          );

          test(
            'should return CacheFailure when there is no cached data',
            () async {
              // arrange
              when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              // act
              final result = await repository.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
              verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
              expect(
                result,
                equals(
                  Left(CacheFailure()),
                ),
              );
            },
          );
        },
      );
    },
  );
}
