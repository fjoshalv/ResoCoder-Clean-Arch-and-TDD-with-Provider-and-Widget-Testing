import 'package:clean_arch_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/widget_extension.dart';

void main() {
  const message = "Test";
  testWidgets(
    'Should verify layout elements',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MessageDisplay(
          message: message,
        ).wrapWithMaterialAndScaffold(),
      );

      // Act
      final messageWidget = find.byType(Text);

      // Assert
      expect(messageWidget, findsOneWidget);
    },
  );

  testWidgets(
    'should check that correct info is displayed',
    (tester) async {
      //arrange
      await tester.pumpWidget(
        const MessageDisplay(
          message: message,
        ).wrapWithMaterialAndScaffold(),
      );
      //act
      final messageText = find.text(message);
      //assert
      expect(messageText, findsOneWidget);
    },
  );
}
