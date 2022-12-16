import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:clean_arch_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        centerTitle: false,
      ),
      body: const SingleChildScrollView(
        child: _NTPBody(),
      ),
    );
  }
}

class _NTPBody extends StatelessWidget {
  const _NTPBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NumberTriviaProvider(
        getConcreteNumberTrivia: serviceLocator(),
        getRandomNumberTrivia: serviceLocator(),
        inputConverter: serviceLocator(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            // Top half
            Consumer<NumberTriviaProvider>(
                builder: (context, numberTriviaProvider, child) {
              if (numberTriviaProvider.currentTrivia == null &&
                  !numberTriviaProvider.hasError) {
                return const MessageDisplay(
                  message: 'Start searching!',
                );
              } else if (numberTriviaProvider.isLoading) {
                return const LoadingWidget();
              } else if (numberTriviaProvider.currentTrivia != null) {
                return TriviaDisplay(
                  numberTrivia: numberTriviaProvider.currentTrivia!,
                );
              } else if (numberTriviaProvider.hasError) {
                return MessageDisplay(
                  message: numberTriviaProvider.errorMessage!,
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(
              height: 20.0,
            ),
            // Bottom half
            const TriviaControls()
          ],
        ),
      ),
    );
  }
}
