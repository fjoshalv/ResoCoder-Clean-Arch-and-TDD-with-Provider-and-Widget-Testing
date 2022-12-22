import 'package:clean_arch_tdd/core/values/app_strings.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.numberTrivia),
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
    return Padding(
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
            if (numberTriviaProvider.isLoading) {
              return const LoadingWidget();
            } else if (numberTriviaProvider.hasError) {
              return MessageDisplay(
                message: numberTriviaProvider.errorMessage!,
              );
            } else if (numberTriviaProvider.currentTrivia != null) {
              return TriviaDisplay(
                numberTrivia: numberTriviaProvider.currentTrivia!,
              );
            }
            return const MessageDisplay(
              message: AppStrings.startSearching,
            );
          }),
          const SizedBox(
            height: 20.0,
          ),
          // Bottom half
          const TriviaControls()
        ],
      ),
    );
  }
}
