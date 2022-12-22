import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension WidgetExt on Widget {
  Widget wrapWithMaterialAndNumberTriviaProvider(
    NumberTriviaProvider provider,
  ) =>
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: this,
        ),
      );
  Widget wrapWithMaterialAndScaffold() => MaterialApp(
        home: Scaffold(
          body: this,
        ),
      );
}
