import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/widget_extension.dart';

void main() {
  const tNumberTrivia = NumberTrivia(text: 'Test', number: 1);
  testWidgets(
    'Should verify layout elements',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        const TriviaDisplay(
          numberTrivia: tNumberTrivia,
        ).wrapWithMaterialAndScaffold(),
      );

      // Act
      final messageWidget = find.byType(Text);

      // Assert
      expect(messageWidget, findsNWidgets(2));
    },
  );
  testWidgets(
    'should check that correct info is displayed',
    (tester) async {
      //arrange
      await tester.pumpWidget(
        const TriviaDisplay(
          numberTrivia: tNumberTrivia,
        ).wrapWithMaterialAndScaffold(),
      );
      //act
      final numberText = find.text(tNumberTrivia.number.toString());
      final triviaText = find.text(tNumberTrivia.text);
      //assert
      expect(numberText, findsOneWidget);
      expect(triviaText, findsOneWidget);
    },
  );
}
