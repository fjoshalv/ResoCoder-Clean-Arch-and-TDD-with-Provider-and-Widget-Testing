import 'dart:convert';

import 'package:clean_arch_tdd/core/error/exceptions.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import '../../../../fixtures/fixture_names.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

// Future<Response<T>> getShim<T>(
//   String? path, {
//   Map<String, dynamic>? queryParameters,
//   Options? options,
//   CancelToken? cancelToken,
//   void Function(int, int)? onReceiveProgress,
// }) {
//   options = MockOptions();
//   return Future.value(Response(requestOptions: RequestOptions(path: '')));
// }

// @GenerateMocks([
//   Dio,
//   Options,
//   Response,
//   RequestOptions
// ], customMocks: [
//   MockSpec<Dio>(
//     as: #CustomDioMock,
//     fallbackGenerators: {
//       #get: getShim,
//     },
//   )
// ])

@GenerateMocks([
  Dio,
  Response,
  RequestOptions,
])
@GenerateNiceMocks([MockSpec<Options>()])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockOptions mockOptions;
  late MockResponse mockResponse;
  late MockRequestOptions mockRequestOptions;
  final tSuccessfulResponse = Response(
    requestOptions: RequestOptions(
      path: '',
    ),
    statusCode: 200,
    data: fixture(FixtureNames.trivia),
  );
  final tUnsuccessfulResponse = Response(
    requestOptions: RequestOptions(
      path: '',
    ),
    statusCode: 404,
  );

  final tNumberTriviaModel = NumberTriviaModel.fromJson(
    json.decode(
      fixture(FixtureNames.trivia),
    ),
  );

  setUp(() {
    mockRequestOptions = MockRequestOptions();
    mockDio = MockDio();
    mockOptions = MockOptions();
    dataSource = NumberTriviaRemoteDataSourceImpl(
      client: mockDio,
      options: mockOptions,
    );
    mockResponse = MockResponse();
  });

  void stubMockDioSuccessResponse() {
    when(
      mockDio.get(
        any,
        options: mockOptions,
      ),
    ).thenAnswer(
      (_) async => tSuccessfulResponse,
    );
  }

  void stubUnsuccessfulResponse() {
    when(
      mockDio.get(
        any,
        options: mockOptions,
      ),
    ).thenAnswer(
      (_) async => tUnsuccessfulResponse,
    );
  }

  final headersMap = {'Content-Type': 'application/json'};
  group(
    "getConcreteNumberTrivia",
    () {
      const tNumber = 1;
      test(
        '''
          should perform a GET request on a URL with number
          being the endpoint and with "application/json" header
        ''',
        () async {
          // arrange
          stubMockDioSuccessResponse();
          // act
          dataSource.getConcreteNumberTrivia(tNumber);
          // assert

          verify(
            mockDio.get(
              'http://numbersapi.com/$tNumber',
              options: mockOptions,
            ),
          );

          final passedHeaders = verify(
            mockOptions.headers = captureAny,
          ).captured.first;

          expect(
            passedHeaders,
            equals(headersMap),
          );

          final passedResponseType = verify(
            mockOptions.responseType = captureAny,
          ).captured.first;

          expect(
            passedResponseType,
            equals(ResponseType.plain),
          );
        },
      );

      test(
        'should return NumberTrivia when response code is 200 (success)',
        () async {
          //arrange
          stubMockDioSuccessResponse();
          //act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          //assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw a ServerException when the response is not 200',
        () {
          //arrange
          stubUnsuccessfulResponse();
          //act
          final call = dataSource.getConcreteNumberTrivia;
          //assert
          expect(
            () => call(tNumber),
            throwsA(
              isA<ServerException>(),
            ),
          );
        },
      );
    },
  );

  group(
    "getRandomNumberTrivia",
    () {
      test(
        '''
          should perform a GET request on a URL with number
          being the endpoint and with "application/json" header
        ''',
        () async {
          // arrange
          stubMockDioSuccessResponse();
          // act
          dataSource.getRandomNumberTrivia();
          // assert

          verify(
            mockDio.get(
              'http://numbersapi.com/random',
              options: mockOptions,
            ),
          );

          final passedHeaders = verify(
            mockOptions.headers = captureAny,
          ).captured.first;

          expect(
            passedHeaders,
            equals(headersMap),
          );

          final passedResponseType = verify(
            mockOptions.responseType = captureAny,
          ).captured.first;

          expect(
            passedResponseType,
            equals(ResponseType.plain),
          );
        },
      );

      test(
        'should return NumberTrivia when response code is 200 (success)',
        () async {
          //arrange
          stubMockDioSuccessResponse();
          //act
          final result = await dataSource.getRandomNumberTrivia();
          //assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw a ServerException when the response is not 200',
        () {
          //arrange
          stubUnsuccessfulResponse();
          //act
          final call = dataSource.getRandomNumberTrivia;
          //assert
          expect(
            call,
            throwsA(
              isA<ServerException>(),
            ),
          );
        },
      );
    },
  );
}
