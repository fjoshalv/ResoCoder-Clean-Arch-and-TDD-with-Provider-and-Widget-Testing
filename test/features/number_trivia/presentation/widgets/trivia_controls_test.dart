import 'package:clean_arch_tdd/core/values/app_strings.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/widget_extension.dart';

void main() {
  testWidgets(
    'Should verify layout elements',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        const TriviaControls().wrapWithMaterialAndScaffold(),
      );

      // Act
      final inputTextField = find.byType(TextField);
      final searchButton =
          find.widgetWithText(ElevatedButton, AppStrings.search);
      final randomButton =
          find.widgetWithText(ElevatedButton, AppStrings.getRandomTrivia);

      // Assert
      expect(inputTextField, findsOneWidget);
      expect(searchButton, findsOneWidget);
      expect(randomButton, findsOneWidget);
    },
  );

  testWidgets(
    'should check that text field only accepts digits',
    (tester) async {
      //arrange
      await tester.pumpWidget(
        const TriviaControls().wrapWithMaterialAndScaffold(),
      );
      //act
      final inputTextField = find.byType(TextField);
      await tester.enterText(inputTextField, 'aaa');
      final inputTextFieldByValue = find.widgetWithText(TextField, 'aaa');
      //assert
      expect(inputTextFieldByValue, findsNothing);
    },
  );
}
