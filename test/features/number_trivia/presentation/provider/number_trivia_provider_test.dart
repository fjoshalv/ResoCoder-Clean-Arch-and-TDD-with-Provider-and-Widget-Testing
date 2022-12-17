import 'package:clean_arch_tdd/core/error/failures.dart';
import 'package:clean_arch_tdd/core/use_cases/use_case.dart';
import 'package:clean_arch_tdd/core/utils/input_converter.dart';
import 'package:clean_arch_tdd/core/values/app_strings.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/change_notifier_callback.dart';
import 'number_trivia_provider_test.mocks.dart';

@GenerateNiceMocks(
  [
    MockSpec<GetConcreteNumberTrivia>(),
    MockSpec<GetRandomNumberTrivia>(),
    MockSpec<InputConverter>(),
  ],
)
@GenerateMocks(
  [ChangeNotifierCallback],
)
void main() {
  late NumberTriviaProvider numberTriviaProvider;
  late MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  late MockGetRandomNumberTrivia getRandomNumberTrivia;
  late MockInputConverter inputConverter;
  late MockChangeNotifierCallback changeNotifierCallback;

  setUp(
    () {
      getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      getRandomNumberTrivia = MockGetRandomNumberTrivia();
      inputConverter = MockInputConverter();
      numberTriviaProvider = NumberTriviaProvider(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter,
      );
      changeNotifierCallback = MockChangeNotifierCallback();
      numberTriviaProvider.addListener(changeNotifierCallback);
    },
  );
  test(
    'should check initial value of state variables',
    () {
      //assert
      expect(numberTriviaProvider.errorMessage, equals(null));
      expect(numberTriviaProvider.isLoading, equals(false));
      expect(numberTriviaProvider.currentTrivia, null);
      verifyNever(changeNotifierCallback());
    },
  );
  group(
    "getTriviaForConcreteNumber",
    () {
      const tNumberString = '1';
      const tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

      void stubInputConverterSuccess() => when(
            inputConverter.stringToUnsignedInteger(any),
          ).thenReturn(
            const Right(tNumberParsed),
          );

      void stubGetConcreteNumberTriviaSuccess() =>
          when(getConcreteNumberTrivia(any)).thenAnswer(
            (_) async => const Right(tNumberTrivia),
          );

      test(
        'should call the input converter to validate and convert the string to an unsigned integer (mostly ensure the converter was called)',
        () {
          // arrange
          stubInputConverterSuccess();
          stubGetConcreteNumberTriviaSuccess();
          // act
          numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      test(
        '''
          should check that [isLoading] switches its value correctly when 
          calling [getTriviaForConcreteNumber] and notify listeners
        ''',
        () async {
          // arrange
          stubInputConverterSuccess();
          stubGetConcreteNumberTriviaSuccess();
          // act
          final result =
              numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert
          expect(
            numberTriviaProvider.isLoading,
            equals(true),
          );
          await result;
          expect(
            numberTriviaProvider.isLoading,
            equals(false),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check that error is caught when input is invalid and notify listener',
        () {
          // arrange
          when(
            inputConverter.stringToUnsignedInteger(any),
          ).thenReturn(
            Left(InvalidInputFailure()),
          );
          // act
          numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert

          expect(
            numberTriviaProvider.errorMessage,
            equals(AppStrings.invalidInputMessage),
          );
          verify(changeNotifierCallback()).called(1);
        },
      );
      test(
        'should get data from the concrete use case',
        () async {
          // arrange
          stubInputConverterSuccess();
          stubGetConcreteNumberTriviaSuccess();
          // act
          await numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert
          verify(
            getConcreteNumberTrivia(
              const Params(number: tNumberParsed),
            ),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check [currentTrivia] when call to use case is successful',
        () async {
          //arrange
          stubInputConverterSuccess();
          stubGetConcreteNumberTriviaSuccess();
          //act
          await numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert
          expect(
            numberTriviaProvider.currentTrivia,
            equals(tNumberTrivia),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check [currentTrivia] and [errorMessage] when getting data fails',
        () async {
          //arrange
          stubInputConverterSuccess();
          when(getConcreteNumberTrivia(any)).thenAnswer(
            (_) async => Left(ServerFailure()),
          );
          //act
          await numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert
          expect(
            numberTriviaProvider.currentTrivia,
            null,
          );

          expect(
            numberTriviaProvider.errorMessage,
            equals(AppStrings.serverFailureMessage),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check [currentTrivia] and [errorMessage] with a proper message for the error when getting data fails',
        () async {
          //arrange
          stubInputConverterSuccess();
          when(getConcreteNumberTrivia(any)).thenAnswer(
            (_) async => Left(CacheFailure()),
          );
          //act
          await numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert
          expect(
            numberTriviaProvider.currentTrivia,
            null,
          );

          expect(
            numberTriviaProvider.errorMessage,
            equals(AppStrings.cacheFailureMessage),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check [errorMessage] is null when a subsequent try is successful',
        () async {
          //! Part one - trigger error so that [errorMessage] has a value.
          //arrange
          // TODO: Refactor this to reutilize
          when(inputConverter.stringToUnsignedInteger(any)).thenReturn(
            Left(InvalidInputFailure()),
          );
          //act
          await numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          //! Part two - trigger successful call
          // arrange
          stubInputConverterSuccess();
          stubGetConcreteNumberTriviaSuccess();
          // act
          await numberTriviaProvider.getTriviaForConcreteNumber(tNumberString);
          // assert
          expect(numberTriviaProvider.errorMessage, equals(null));
          verify(changeNotifierCallback()).called(3);
        },
      );
    },
  );

  group(
    "getTriviaForRandomNumber",
    () {
      const tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

      test(
        'should check that [isLoading] switches its value correctly when calling [getTriviaForRandomNumber]',
        () async {
          // arrange
          when(getRandomNumberTrivia(any)).thenAnswer(
            (_) async => const Right(tNumberTrivia),
          );
          // act
          final result = numberTriviaProvider.getTriviaForRandomNumber();
          // assert
          expect(
            numberTriviaProvider.isLoading,
            equals(true),
          );
          await result;
          expect(
            numberTriviaProvider.isLoading,
            equals(false),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should get data from the random use case',
        () async {
          // arrange
          when(getRandomNumberTrivia(any)).thenAnswer(
            (_) async => const Right(tNumberTrivia),
          );
          // act
          await numberTriviaProvider.getTriviaForRandomNumber();
          // assert
          verify(
            getRandomNumberTrivia(
              NoParams(),
            ),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check [currentTrivia] when call to use case is successful',
        () async {
          // arrange
          when(getRandomNumberTrivia(any)).thenAnswer(
            (_) async => const Right(tNumberTrivia),
          );
          // act
          await numberTriviaProvider.getTriviaForRandomNumber();
          // assert
          expect(
            numberTriviaProvider.currentTrivia,
            equals(tNumberTrivia),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );
      // TODO: Refactor this!!! (and also on the other group)
      test(
        'should check [currentTrivia] and [errorMessage] when getting data fails',
        () async {
          // arrange
          when(getRandomNumberTrivia(any)).thenAnswer(
            (_) async => Left(ServerFailure()),
          );
          // act
          await numberTriviaProvider.getTriviaForRandomNumber();
          // assert
          expect(
            numberTriviaProvider.currentTrivia,
            null,
          );

          expect(
            numberTriviaProvider.errorMessage,
            equals(AppStrings.serverFailureMessage),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check [currentTrivia] and [errorMessage] with a proper message for the error when getting data fails',
        () async {
          // arrange
          when(getRandomNumberTrivia(any)).thenAnswer(
            (_) async => Left(CacheFailure()),
          );
          // act
          await numberTriviaProvider.getTriviaForRandomNumber();
          // assert
          expect(
            numberTriviaProvider.currentTrivia,
            null,
          );

          expect(
            numberTriviaProvider.errorMessage,
            equals(AppStrings.cacheFailureMessage),
          );
          verify(changeNotifierCallback()).called(2);
        },
      );

      test(
        'should check [errorMessage] is null when a subsequent try is successful',
        () async {
          //! Part one - trigger error so that [errorMessage] has a value.
          //arrange
          when(getRandomNumberTrivia(any)).thenAnswer(
            (_) async => Left(CacheFailure()),
          );
          //act
          await numberTriviaProvider.getTriviaForRandomNumber();
          //! Part two - trigger successful call
          // arrange
          // TODO: Refactor this
          when(getRandomNumberTrivia(any)).thenAnswer(
            (_) async => const Right(tNumberTrivia),
          );
          // act
          await numberTriviaProvider.getTriviaForRandomNumber();
          // assert
          expect(numberTriviaProvider.errorMessage, equals(null));
          verify(changeNotifierCallback()).called(4);
        },
      );
    },
  );
}
