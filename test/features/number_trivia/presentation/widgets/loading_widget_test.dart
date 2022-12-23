import 'package:clean_arch_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/widget_extension.dart';

void main() {
  testWidgets(
    'Should verify layout elements',
    (tester) async {
      // Arrange
      await tester
          .pumpWidget(const LoadingWidget().wrapWithMaterialAndScaffold());

      // Act
      final loadingWidget = find.byType(CircularProgressIndicator);

      // Assert
      expect(loadingWidget, findsOneWidget);
    },
  );
}
