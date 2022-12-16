import 'package:clean_arch_tdd/core/use_cases/use_case.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  // Declare classes we are using
  late GetRandomNumberTrivia getRandomNumberTrivia;
  late NumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getRandomNumberTrivia = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia =
      NumberTrivia(text: 'Test Number Trivia', number: tNumber);

  test(
    "should get trivia from the repository",
    () async {
      // Arrange
      when(
        mockNumberTriviaRepository.getRandomNumberTrivia(),
      ).thenAnswer(
        (_) async => const Right(tNumberTrivia),
      );
      // Act
      final result = await getRandomNumberTrivia(NoParams());
      // Assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
