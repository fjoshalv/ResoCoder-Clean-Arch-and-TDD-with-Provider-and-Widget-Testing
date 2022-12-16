import 'package:clean_arch_tdd/core/network/network_info.dart';
import 'package:clean_arch_tdd/core/utils/input_converter.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Use cases
  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(
      serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Data Sources
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: serviceLocator(),
      options: serviceLocator(),
    ),
  );

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: serviceLocator(),
    ),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton(
    () => Dio(),
  );
  serviceLocator.registerLazySingleton(
    () => Options(),
  );
  serviceLocator.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
}
