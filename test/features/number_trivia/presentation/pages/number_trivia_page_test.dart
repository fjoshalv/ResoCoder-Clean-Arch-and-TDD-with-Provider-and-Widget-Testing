import 'package:clean_arch_tdd/core/values/app_strings.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/widget_extension.dart';

class FakeNumberTriviaProvider extends Fake
    with ChangeNotifier
    implements NumberTriviaProvider {
  @override
  bool isLoading = false;

  @override
  bool get hasError => errorMessage != null;

  @override
  String? errorMessage;

  @override
  NumberTrivia? currentTrivia;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

void main() {
  const tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);
  late FakeNumberTriviaProvider fakeNumberTriviaProvider;
  setUp(
    () {
      fakeNumberTriviaProvider = FakeNumberTriviaProvider();
    },
  );

  group(
    "Consumer Widget -",
    () {
      testWidgets(
        'Should check that "Start searching!" text is displayed on initial',
        (tester) async {
          // Arrange
          await tester.pumpWidget(
            const NumberTriviaPage().wrapWithMaterialAndNumberTriviaProvider(
                fakeNumberTriviaProvider),
          );
          // Act
          final initialValue = find.text(AppStrings.startSearching);
          // assert
          expect(initialValue, findsOneWidget);
        },
      );

      testWidgets(
        'Should check that Loading widget appears when isLoading is true',
        (tester) async {
          // Arrange
          await tester.pumpWidget(
            const NumberTriviaPage().wrapWithMaterialAndNumberTriviaProvider(
                fakeNumberTriviaProvider),
          );

          // Act
          fakeNumberTriviaProvider.isLoading = true;
          fakeNumberTriviaProvider.notifyListeners();
          await tester.pump();
          final loadingWidget = find.byType(LoadingWidget);

          // Assert
          expect(loadingWidget, findsOneWidget);
        },
      );

      testWidgets(
        'Should check that Error message appears when errorMessage is not null',
        (tester) async {
          // Arrange
          await tester.pumpWidget(
            const NumberTriviaPage().wrapWithMaterialAndNumberTriviaProvider(
                fakeNumberTriviaProvider),
          );

          // Act
          fakeNumberTriviaProvider.errorMessage = "This is a test";
          fakeNumberTriviaProvider.notifyListeners();
          await tester.pump();
          final messageDisplayFinder = find.byType(MessageDisplay);
          final messageDisplay =
              tester.firstWidget<MessageDisplay>(messageDisplayFinder);
          // Assert
          expect(messageDisplayFinder, findsOneWidget);
          expect(messageDisplay.message, fakeNumberTriviaProvider.errorMessage);
        },
      );

      testWidgets(
        'Should check that trivia appears when currentTrivia is not null',
        (tester) async {
          // Arrange
          await tester.pumpWidget(
            const NumberTriviaPage().wrapWithMaterialAndNumberTriviaProvider(
                fakeNumberTriviaProvider),
          );

          // Act
          fakeNumberTriviaProvider.currentTrivia = tNumberTrivia;
          fakeNumberTriviaProvider.notifyListeners();
          await tester.pump();
          final triviaDisplayFinder = find.byType(TriviaDisplay);
          final triviaDisplay =
              tester.firstWidget<TriviaDisplay>(triviaDisplayFinder);
          // Assert
          expect(triviaDisplayFinder, findsOneWidget);
          expect(triviaDisplay.numberTrivia, tNumberTrivia);
        },
      );
    },
  );

  group(
    "App Bar -",
    () {
      testWidgets(
        'Should check that app bar contains correct title',
        (tester) async {
          // Arrange
          await tester.pumpWidget(
            const NumberTriviaPage().wrapWithMaterialAndNumberTriviaProvider(
              fakeNumberTriviaProvider,
            ),
          );
          // Act
          final appBarTitle =
              find.widgetWithText(AppBar, AppStrings.numberTrivia);
          // assert
          expect(appBarTitle, findsOneWidget);
        },
      );
    },
  );

  // testWidgets(
  //   'Should have one field to enter number trivia',
  //   (tester) async {
  //     // Arrange
  //     await tester.pumpWidget(
  //       const NumberTriviaPage().wrapWithMaterialAndNumberTriviaProvider(
  //         MockNumberTriviaProvider(),
  //       ),
  //     );

  //     //Act
  //     final numberTriviaTextField = find.byType(TextField);

  //     // Assert
  //     expect(numberTriviaTextField, findsOneWidget);
  //   },
  // );
}
